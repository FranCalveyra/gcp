provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_compute_network" "vpc" {
  name = var.network_name
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "cloudsql-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.vpc.id

  depends_on = [google_project_service.enabled]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [google_project_service.enabled]
}

resource "google_sql_database_instance" "wordpress_db" {
  name                = var.sql_instance_name
  project             = var.project_id
  region              = var.region
  database_version    = var.sql_database_version
  root_password       = var.sql_root_password
  deletion_protection = false

  settings {
    tier = var.sql_tier

    ip_configuration {
      ipv4_enabled    = true
      private_network = data.google_compute_network.vpc.id
      ssl_mode        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    backup_configuration {
      enabled = true
    }

    user_labels = var.labels
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "wordpress" {
  name     = var.wordpress_database_name
  project  = var.project_id
  instance = google_sql_database_instance.wordpress_db.name
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-wordpress-http"
  network = data.google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wordpress-http"]
}

resource "google_compute_instance" "wordpress_proxy" {
  name         = "wordpress-proxy"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["wordpress-http"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
    }
  }

  network_interface {
    network = data.google_compute_network.vpc.name
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl enable apache2
    systemctl restart apache2
  EOT

  depends_on = [google_project_service.enabled]
}

resource "google_compute_instance" "wordpress_private_ip" {
  name         = "wordpress-private-ip"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["wordpress-http"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
    }
  }

  network_interface {
    network = data.google_compute_network.vpc.name
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl enable apache2
    systemctl restart apache2
  EOT

  depends_on = [google_project_service.enabled]
}
