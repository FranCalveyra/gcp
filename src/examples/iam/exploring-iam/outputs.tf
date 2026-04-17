output "bucket_name" {
  description = "Nombre del bucket creado para la practica."
  value       = google_storage_bucket.lab_bucket.name
}

output "bucket_url" {
  description = "URL gs:// del bucket de prueba."
  value       = "gs://${google_storage_bucket.lab_bucket.name}"
}

output "sample_object_url" {
  description = "Ruta gs:// del objeto de muestra."
  value       = "gs://${google_storage_bucket.lab_bucket.name}/${google_storage_bucket_object.sample.name}"
}

output "service_account_email" {
  description = "Email del service account adjunto a la VM."
  value       = google_service_account.read_bucket_objects.email
}

output "vm_name" {
  description = "Nombre de la VM creada."
  value       = google_compute_instance.demoiam.name
}

output "vm_zone" {
  description = "Zona donde se creo la VM."
  value       = google_compute_instance.demoiam.zone
}

output "service_account_bucket_roles" {
  description = "Roles efectivos del service account sobre el bucket."
  value       = sort(tolist(var.service_account_bucket_roles))
}

output "verification_commands" {
  description = "Comandos sugeridos para validar el comportamiento del lab."
  value = {
    list_bucket_from_limited_principal = "gcloud storage ls gs://${google_storage_bucket.lab_bucket.name}"
    download_sample_from_vm            = "gcloud storage cp gs://${google_storage_bucket.lab_bucket.name}/${google_storage_bucket_object.sample.name} ."
    upload_sample_from_vm              = "gcloud storage cp sample2.txt gs://${google_storage_bucket.lab_bucket.name}"
  }
}
