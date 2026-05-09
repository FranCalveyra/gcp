output "app_engine_location_id" {
  description = "Location ID configurado para App Engine."
  value       = google_app_engine_application.app.location_id
}

output "monitoring_app_engine_service_id" {
  description = "Service ID de Monitoring para el App Engine service default."
  value       = data.google_monitoring_app_engine_service.default.service_id
}

output "slo_name" {
  description = "Nombre completo del SLO creado."
  value       = google_monitoring_slo.availability.name
}

output "alert_policy_name" {
  description = "Nombre del alert policy creado."
  value       = google_monitoring_alert_policy.slo_burn_rate.name
}

output "notification_channel_name" {
  description = "Nombre del notification channel (si se creo)."
  value       = var.notification_email == null ? null : google_monitoring_notification_channel.email[0].name
}

