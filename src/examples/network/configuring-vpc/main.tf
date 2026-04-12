provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  instance_zones = {
    "mynet-vm-1" = var.zone_1
    "mynet-vm-2" = var.zone_2
  }

  common_labels = merge(var.labels, {
    network = var.network_name
  })
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_network" "mynetwork" {
  name                    = var.network_name
  auto_create_subnetworks = true
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

resource "google_compute_firewall" "allow_ssh_from_cloud_shell" {
  name    = "${var.network_name}-ingress-allow-ssh-from-cs"
  network = google_compute_network.mynetwork.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.ssh_source_cidr]
  target_tags   = [var.ssh_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_icmp_internal" {
  name    = "${var.network_name}-ingress-allow-icmp-internal"
  network = google_compute_network.mynetwork.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.internal_icmp_source_range]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "deny_icmp_ingress" {
  name    = "${var.network_name}-ingress-deny-icmp-all"
  network = google_compute_network.mynetwork.name

  direction = "INGRESS"
  priority  = 2000

  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "deny_icmp_egress" {
  name    = "${var.network_name}-egress-deny-icmp-all"
  network = google_compute_network.mynetwork.name

  direction = "EGRESS"
  priority  = 10000

  destination_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "icmp"
  }
}

resource "google_compute_instance" "vms" {
  for_each = local.instance_zones

  name         = each.key
  machine_type = var.machine_type
  zone         = each.value
  tags         = [var.ssh_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    network = google_compute_network.mynetwork.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    cat >/etc/motd <<'EOF'
    Configuring VPC Firewalls lab VM: ${each.key}
    EOF
  EOT

  depends_on = [google_project_service.enabled]
}
