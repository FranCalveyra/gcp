terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_compute_image" "web_image" {
  family  = var.instance_image_family
  project = var.instance_image_project
}

locals {
  # Use a map for stable for_each keys and cleaner references.
  instance_map = {
    for name in var.instance_names : name => name
  }
}

resource "google_compute_instance" "web" {
  for_each     = local.instance_map
  name         = each.value
  machine_type = var.instance_machine_type
  zone         = var.zone
  tags         = [var.instance_network_tag]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.web_image.self_link
    }
  }

  network_interface {
    network = var.network_name
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install apache2 -y
    service apache2 restart
    echo "<h3>Web Server: ${each.value}</h3>" | tee /var/www/html/index.html
  EOT
}

resource "google_compute_firewall" "www_firewall_network_lb" {
  name    = var.firewall_rule_name
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = [tostring(var.http_port)]
  }

  target_tags = [var.instance_network_tag]
}

resource "google_compute_http_health_check" "basic_check" {
  name = var.health_check_name
  port = var.http_port
}

resource "google_compute_target_pool" "www_pool" {
  name   = var.target_pool_name
  region = var.region

  health_checks = [google_compute_http_health_check.basic_check.self_link]
  instances = [
    for name in var.instance_names : google_compute_instance.web[name].self_link
  ]
}

resource "google_compute_address" "network_lb_ip_1" {
  name   = var.forwarding_rule_address_name
  region = var.region
}

resource "google_compute_forwarding_rule" "www_rule" {
  name                  = var.forwarding_rule_name
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = tostring(var.http_port)
  ip_address            = google_compute_address.network_lb_ip_1.address
  target                = google_compute_target_pool.www_pool.self_link
}

output "load_balancer_ip" {
  description = "External IPv4 address of the Network Load Balancer."
  value       = google_compute_address.network_lb_ip_1.address
}
