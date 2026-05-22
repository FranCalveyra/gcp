output "pdf_converter_url" {
  description = "URL privada del servicio pdf-converter."
  value       = google_cloud_run_v2_service.pdf_converter.uri
}

output "upload_bucket" {
  description = "Nombre del bucket de upload (trigger de conversiones)."
  value       = google_storage_bucket.upload.name
}

output "processed_bucket" {
  description = "Nombre del bucket donde se almacenan los PDFs convertidos."
  value       = google_storage_bucket.processed.name
}

output "pubsub_topic" {
  description = "Nombre del topic de Pub/Sub."
  value       = google_pubsub_topic.new_doc.name
}

output "invoker_service_account_email" {
  description = "Email de la service account usada para invocar pdf-converter."
  value       = google_service_account.invoker.email
}
