provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.app_engine_location_id

  depends_on = [google_project_service.enabled]
}

resource "google_monitoring_notification_channel" "email" {
  count        = var.notification_email == null ? 0 : 1
  project      = var.project_id
  display_name = "Email (Terraform): ${var.notification_email}"
  type         = "email"
  labels = {
    email_address = var.notification_email
  }

  depends_on = [google_project_service.enabled]
}

resource "google_monitoring_alert_policy" "app_engine_latency" {
  project      = var.project_id
  display_name = "App Engine: 99th% latency > ${var.latency_threshold_seconds}s"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "GAE response latency (99th percentile)"

    condition_threshold {
      filter          = "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" AND resource.type=\"gae_app\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.latency_threshold_seconds

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
        cross_series_reducer = "REDUCE_NONE"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_email == null ? [] : [google_monitoring_notification_channel.email[0].name]

  user_labels = var.labels

  depends_on = [google_app_engine_application.app]
}

