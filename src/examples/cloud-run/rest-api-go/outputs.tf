output "rest_api_url" {
  description = "URL publica del servicio rest-api en Cloud Run."
  value       = google_cloud_run_v2_service.rest_api.uri
}

output "customer_bucket" {
  description = "Nombre del bucket de Cloud Storage para datos de clientes."
  value       = google_storage_bucket.customer_data.name
}

output "firestore_database" {
  description = "Nombre de la base de datos Firestore."
  value       = google_firestore_database.default.name
}
