output "lab_report_service_url" {
  description = "URL publica de lab-report-service (endpoint del productor)."
  value       = google_cloud_run_v2_service.lab_report.uri
}

output "email_service_url" {
  description = "URL privada de email-service."
  value       = google_cloud_run_v2_service.email.uri
}

output "sms_service_url" {
  description = "URL privada de sms-service."
  value       = google_cloud_run_v2_service.sms.uri
}

output "pubsub_topic" {
  description = "Nombre del topic de Pub/Sub."
  value       = google_pubsub_topic.lab_report.name
}

output "invoker_service_account_email" {
  description = "Email de la service account usada para invocar los consumidores."
  value       = google_service_account.pubsub_cloud_run_invoker.email
}
