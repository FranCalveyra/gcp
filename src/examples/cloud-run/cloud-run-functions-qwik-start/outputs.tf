output "event_bucket_name" {
  description = "Bucket usado para disparar eventos de Cloud Storage."
  value       = google_storage_bucket.events.name
}

output "function_names" {
  description = "Nombres de todas las funciones desplegadas."
  value       = { for k, v in google_cloudfunctions2_function.functions : k => v.name }
}

output "http_function_urls" {
  description = "URLs de funciones HTTP (si disponibles en service_config)."
  value = {
    for k, v in google_cloudfunctions2_function.functions :
    k => v.service_config[0].uri
    if local.functions[k].trigger_type == "http"
  }
}

output "audit_function_name" {
  description = "Funcion que procesa Cloud Audit Logs."
  value       = google_cloudfunctions2_function.functions["gce_vm_labeler"].name
}

output "storage_function_name" {
  description = "Funcion disparada por eventos de Cloud Storage."
  value       = google_cloudfunctions2_function.functions["nodejs_storage"].name
}
