provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  subnet_self_link = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnet_name}"

  common_labels = merge(var.labels, {
    network = var.network_name
  })
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_network" "vpc_net" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  network       = google_compute_network.vpc_net.id
  region        = var.region
  ip_cidr_range = var.subnet_cidr

  log_config {
    aggregation_interval = var.flow_logs_interval
    flow_sampling        = var.flow_logs_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc_net.name

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.http_server_tag]

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.http_server_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' > /var/www/html/index.html
    systemctl enable apache2
    systemctl start apache2
  EOT

  depends_on = [google_project_service.enabled]
}

resource "google_bigquery_dataset" "bq_vpcflows" {
  dataset_id  = var.bq_dataset_id
  location    = "US"
  description = "Dataset para análisis de VPC Flow Logs."
  labels      = local.common_labels

  depends_on = [google_project_service.enabled]
}

resource "google_logging_project_sink" "vpc_flows" {
  name        = var.log_sink_name
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.bq_vpcflows.dataset_id}"

  filter = "resource.type=\"gce_subnetwork\" AND log_name=\"projects/${var.project_id}/logs/compute.googleapis.com%2Fvpc_flows\""

  unique_writer_identity = true
}

resource "google_bigquery_dataset_iam_member" "log_sink_writer" {
  dataset_id = google_bigquery_dataset.bq_vpcflows.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.vpc_flows.writer_identity
}
