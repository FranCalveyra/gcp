provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  web_servers = {
    blue = {
      title = "Welcome to the blue server!"
      tags  = [var.web_server_tag]
    }
    green = {
      title = "Welcome to the green server!"
      tags  = []
    }
  }

  iam_roles = concat(
    ["roles/compute.networkAdmin"],
    var.grant_security_admin ? ["roles/compute.securityAdmin"] : []
  )
}

data "google_compute_network" "target" {
  name = var.network_name
}

data "google_compute_subnetwork" "target" {
  name   = var.subnetwork_name
  region = var.region
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "network_admin" {
  account_id   = var.service_account_name
  display_name = "Network Admin"

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(local.iam_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.network_admin.email}"
}

resource "google_compute_firewall" "allow_http_web_server" {
  name    = "allow-http-web-server"
  network = data.google_compute_network.target.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.web_server_tag]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "icmp"
  }

  depends_on = [google_project_service.enabled]
}

resource "google_compute_instance" "web" {
  for_each = local.web_servers

  name         = each.key
  machine_type = var.machine_type
  zone         = var.zone
  tags         = each.value.tags
  labels       = merge(var.labels, { role = each.key })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.target.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx-light
    cat >/var/www/html/index.nginx-debian.html <<'EOF'
    <h1>${each.value.title}</h1>
    <p>If you see this page, the nginx web server is successfully installed and working. Further configuration is required.</p>
    EOF
    systemctl enable nginx
    systemctl restart nginx
  EOT

  depends_on = [google_project_service.enabled]
}

resource "google_compute_instance" "test_vm" {
  name         = "test-vm"
  machine_type = var.machine_type
  zone         = var.zone
  labels       = merge(var.labels, { role = "test-vm" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.target.id

    access_config {}
  }

  service_account {
    email  = google_service_account.network_admin.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    google_project_service.enabled,
    google_project_iam_member.service_account_roles,
  ]
}
