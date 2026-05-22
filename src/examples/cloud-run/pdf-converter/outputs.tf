output "pdf_converter_url" {
  description = "URL del servicio Cloud Run pdf-converter."
  value       = google_cloud_run_v2_service.pdf_converter.uri
}

output "upload_bucket" {
  description = "Nombre del bucket de upload."
  value       = google_storage_bucket.upload.name
}

output "processed_bucket" {
  description = "Nombre del bucket donde se almacenan los PDFs generados."
  value       = google_storage_bucket.processed.name
}

output "pubsub_topic" {
  description = "Nombre del topic de Pub/Sub que recibe notificaciones de Cloud Storage."
  value       = google_pubsub_topic.new_doc.name
}

output "pubsub_subscription" {
  description = "Nombre de la suscripcion push hacia Cloud Run."
  value       = google_pubsub_subscription.pdf_conv_sub.name
}

output "invoker_service_account_email" {
  description = "Email de la service account que Pub/Sub usa para invocar Cloud Run."
  value       = google_service_account.invoker.email
}
