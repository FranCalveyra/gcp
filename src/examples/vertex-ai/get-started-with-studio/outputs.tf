output "vertex_ai_api_enabled" {
  description = "Indica que la Vertex AI API fue habilitada."
  value       = google_project_service.vertex_ai.service
}

output "cloud_run_sa_email" {
  description = "Email del service account creado para el servicio Cloud Run."
  value       = google_service_account.cloud_run_sa.email
}

output "vertex_ai_studio_url" {
  description = "URL de Vertex AI Studio en la consola."
  value       = "https://console.cloud.google.com/vertex-ai/generative/language/create/text?project=${var.project_id}"
}

output "cloud_run_console_url" {
  description = "URL de Cloud Run en la consola."
  value       = "https://console.cloud.google.com/run?project=${var.project_id}"
}
