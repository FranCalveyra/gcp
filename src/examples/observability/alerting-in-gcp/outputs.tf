output "app_engine_location_id" {
  description = "Location ID configurado para App Engine."
  value       = google_app_engine_application.app.location_id
}

output "alert_policy_name" {
  description = "Nombre del alert policy creado."
  value       = google_monitoring_alert_policy.app_engine_latency.name
}

output "notification_channel_name" {
  description = "Nombre del notification channel (si se creo)."
  value       = var.notification_email == null ? null : google_monitoring_notification_channel.email[0].name
}

