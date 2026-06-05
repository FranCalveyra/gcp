output "dataset_id" {
  description = "ID del dataset de BigQuery creado."
  value       = google_bigquery_dataset.nyctaxi.dataset_id
}

output "dataset_location" {
  description = "Región/ubicación del dataset."
  value       = google_bigquery_dataset.nyctaxi.location
}

output "trips_table_id" {
  description = "ID de la tabla principal de viajes."
  value       = google_bigquery_table.trips_2018.table_id
}

output "january_trips_table_id" {
  description = "ID de la tabla/vista de viajes de enero."
  value       = google_bigquery_table.january_trips.table_id
}

output "bq_console_url" {
  description = "URL de BigQuery Studio para el proyecto."
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}"
}
