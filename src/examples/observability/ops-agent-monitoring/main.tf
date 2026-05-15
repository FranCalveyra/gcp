provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  ops_agent_config = <<-YAML
    metrics:
      receivers:
        apache:
          type: apache
      service:
        pipelines:
          apache:
            receivers:
              - apache
    logging:
      receivers:
        apache_access:
          type: apache_access
        apache_error:
          type: apache_error
      service:
        pipelines:
          apache:
            receivers:
              - apache_access
              - apache_error
  YAML

  startup_script = <<-BASH
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2 php

    curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
    bash add-google-cloud-ops-agent-repo.sh --also-install

    cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak
    cat > /etc/google-cloud-ops-agent/config.yaml << 'EOF'
    ${local.ops_agent_config}EOF

    systemctl restart google-cloud-ops-agent
  BASH
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-ops-agent"
  network = "default"

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.http_server_tag]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  depends_on = [google_project_service.enabled]
}

resource "google_compute_instance" "quickstart_vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [var.http_server_tag]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  # Scope cloud-platform incluye monitoring.write y logging.write necesarios para el Ops Agent
  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = local.startup_script

  depends_on = [google_project_service.enabled]
}

resource "google_monitoring_notification_channel" "email" {
  count = var.alert_notification_email != "" ? 1 : 0

  display_name = "Email Ops Agent Alert"
  type         = "email"

  labels = {
    email_address = var.alert_notification_email
  }
}

resource "google_monitoring_alert_policy" "apache_traffic" {
  count = var.alert_notification_email != "" ? 1 : 0

  display_name = "Apache traffic above threshold"
  combiner     = "OR"

  conditions {
    display_name = "Apache traffic > ${var.apache_traffic_threshold_kbps} B/s"

    condition_threshold {
      filter          = "metric.type=\"workload.googleapis.com/apache.traffic\" AND resource.type=\"gce_instance\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.apache_traffic_threshold_kbps
      duration        = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email[0].name]

  depends_on = [google_project_service.enabled]
}
