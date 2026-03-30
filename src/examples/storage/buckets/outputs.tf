output "bucket_name" {
  description = "Nombre del bucket creado."
  value       = google_storage_bucket.lab_bucket.name
}

output "bucket_url" {
  description = "URL gs:// del bucket."
  value       = "gs://${google_storage_bucket.lab_bucket.name}"
}

output "versioning_enabled" {
  description = "Indica si el bucket tiene versioning habilitado."
  value       = google_storage_bucket.lab_bucket.versioning[0].enabled
}

output "lifecycle_delete_age_days" {
  description = "Días de retención antes de borrar objetos por lifecycle."
  value       = var.lifecycle_delete_age_days
}

output "sample_objects_uploaded" {
  description = "Objetos de ejemplo cargados por Terraform."
  value       = keys(google_storage_bucket_object.samples)
}
