output "app_engine_location_id" {
  description = "Location ID configurado para App Engine."
  value       = google_app_engine_application.app.location_id
}

output "app_engine_url" {
  description = "URL base de la aplicación App Engine."
  value       = "https://${var.project_id}.appspot.com"
}

output "uptime_check_id" {
  description = "ID del uptime check creado."
  value       = google_monitoring_uptime_check_config.app_engine.uptime_check_id
}

output "latency_alert_policy_name" {
  description = "Nombre del alert policy de latencia."
  value       = google_monitoring_alert_policy.app_engine_latency.name
}

output "uptime_alert_policy_name" {
  description = "Nombre del alert policy de uptime."
  value       = google_monitoring_alert_policy.uptime_failure.name
}

output "notification_channel_name" {
  description = "Nombre del notification channel (si se creó)."
  value       = var.notification_email == null ? null : google_monitoring_notification_channel.email[0].name
}
