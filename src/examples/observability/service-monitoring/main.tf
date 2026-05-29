provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  effective_slo_id = var.slo_id != null ? var.slo_id : "availability-rolling-${var.slo_rolling_period_days}d-${replace(tostring(var.slo_goal), ".", "")}"

  burn_rate_query = join("\n", [
    "fetch slo",
    "| select_slo_burn_rate(\"${google_monitoring_slo.availability.name}\", \"${var.burn_rate_lookback_seconds}s\")",
    "| condition val() > ${var.burn_rate_threshold}",
  ])
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

data "google_monitoring_app_engine_service" "default" {
  module_id = "default"

  depends_on = [google_app_engine_application.app]
}

resource "google_monitoring_slo" "availability" {
  service      = data.google_monitoring_app_engine_service.default.service_id
  slo_id       = local.effective_slo_id
  display_name = "Availability SLO (${var.slo_goal * 100}%) - rolling ${var.slo_rolling_period_days}d"

  goal                = var.slo_goal
  rolling_period_days = var.slo_rolling_period_days

  basic_sli {
    availability {}
  }

  user_labels = var.labels

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

resource "google_monitoring_alert_policy" "slo_burn_rate" {
  project      = var.project_id
  display_name = "SLO burn rate: ${google_monitoring_slo.availability.display_name}"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "Burn rate over ${var.burn_rate_lookback_seconds}s > ${var.burn_rate_threshold}"

    condition_monitoring_query_language {
      query    = local.burn_rate_query
      duration = "0s"
    }
  }

  notification_channels = var.notification_email == null ? [] : [google_monitoring_notification_channel.email[0].name]

  user_labels = var.labels

  depends_on = [google_monitoring_slo.availability]
}

