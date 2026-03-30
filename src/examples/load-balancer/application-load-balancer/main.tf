provider "google" {
  project = var.project_id
  region  = var.default_region
}

locals {
  backend_regions = toset([for cfg in values(var.backend_groups) : cfg.region])
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "fw-allow-health-checks"
  network = var.network_name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-checks"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_router" "nat_router" {
  for_each = local.backend_regions

  name    = "router-${each.value}"
  network = var.network_name
  region  = each.value
}

resource "google_compute_router_nat" "nat" {
  for_each = local.backend_regions

  name                               = "nat-${each.value}"
  router                             = google_compute_router.nat_router[each.value].name
  region                             = each.value
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_instance_template" "web" {
  name_prefix  = "${var.instance_template_name}-"
  machine_type = var.machine_type
  tags         = ["allow-health-checks"]

  disk {
    source_image = var.instance_image
    auto_delete  = true
    boot         = true
    disk_type    = "pd-balanced"
    disk_size_gb = 10
  }

  network_interface {
    network    = var.network_name
    stack_type = "IPV4_ONLY"
  }

  metadata = {
    enable-oslogin = "true"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    hostname=$(hostname)
    cat >/var/www/html/index.html <<HTML
    <h1>Application Load Balancer Demo</h1>
    <p>Backend instance: ${hostname}</p>
    HTML
    systemctl enable apache2
    systemctl restart apache2
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "http" {
  name = "http-health-check"

  timeout_sec        = 5
  check_interval_sec = 5

  http_health_check {
    port = 80
  }
}

resource "google_compute_instance_group_manager" "mig" {
  for_each = var.backend_groups

  name               = each.value.name
  base_instance_name = each.value.name
  zone               = each.value.zone
  target_size        = each.value.target_size

  version {
    instance_template = google_compute_instance_template.web.id
    name              = "primary"
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "mig" {
  for_each = var.backend_groups

  name   = "${each.value.name}-autoscaler"
  zone   = each.value.zone
  target = google_compute_instance_group_manager.mig[each.key].id

  autoscaling_policy {
    max_replicas    = each.value.max_replicas
    min_replicas    = each.value.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_backend_service" "http" {
  name                  = "http-backend-service"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.http.id]

  dynamic "backend" {
    for_each = google_compute_instance_group_manager.mig
    content {
      group           = backend.value.instance_group
      balancing_mode  = "UTILIZATION"
      capacity_scaler = 1.0
    }
  }
}

resource "google_compute_url_map" "http" {
  name            = "http-lb-url-map"
  default_service = google_compute_backend_service.http.id
}

resource "google_compute_target_http_proxy" "http" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.http.id
}

resource "google_compute_global_address" "ipv4" {
  name = "http-lb-ipv4"
}

resource "google_compute_global_forwarding_rule" "http_ipv4" {
  name                  = "http-lb-forwarding-rule-ipv4"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http.id
  ip_address            = google_compute_global_address.ipv4.id
}

resource "google_compute_global_forwarding_rule" "http_ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  name                  = "http-lb-forwarding-rule-ipv6"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http.id
  ip_version            = "IPV6"
}
