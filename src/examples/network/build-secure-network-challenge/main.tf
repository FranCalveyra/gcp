provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  required_apis = toset([
    "compute.googleapis.com",
    "iap.googleapis.com",
  ])

  common_labels = merge(var.labels, {
    challenge = "build-secure-network"
    network   = var.network_name
  })
}

resource "google_project_service" "enabled" {
  for_each = local.required_apis

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_network" "acme_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

resource "google_compute_subnetwork" "acme_mgmt" {
  name          = var.mgmt_subnet_name
  ip_cidr_range = var.mgmt_subnet_cidr
  region        = var.region
  network       = google_compute_network.acme_vpc.id
}

resource "google_compute_subnetwork" "acme_web" {
  name          = var.web_subnet_name
  ip_cidr_range = var.web_subnet_cidr
  region        = var.region
  network       = google_compute_network.acme_vpc.id
}

resource "google_compute_firewall" "allow_ssh_iap_ingress" {
  name    = "allow-ssh-iap-ingress"
  network = google_compute_network.acme_vpc.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["35.235.240.0/20"]
  target_tags   = [var.ssh_iap_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_http_ingress" {
  name    = "allow-http-ingress"
  network = google_compute_network.acme_vpc.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.http_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "allow_ssh_internal_ingress" {
  name    = "allow-ssh-internal-ingress"
  network = google_compute_network.acme_vpc.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.mgmt_subnet_cidr]
  target_tags   = [var.ssh_internal_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "bastion" {
  name         = var.bastion_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.ssh_iap_network_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.acme_mgmt.id
    # Sin access_config: sin public IP, acceso SSH exclusivamente vía IAP.
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}

resource "google_compute_instance" "juice_shop" {
  name         = var.juice_shop_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.http_network_tag, var.ssh_internal_network_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.acme_web.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOT
}
