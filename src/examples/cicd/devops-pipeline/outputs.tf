output "artifact_registry_url" {
  description = "URL base del repositorio de Artifact Registry."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.devops_repo.repository_id}"
}

output "image_base_url" {
  description = "URL base de la imagen Docker (sin tag)."
  value       = local.image_base
}

output "cloudbuild_trigger_id" {
  description = "ID del Cloud Build trigger creado."
  value       = google_cloudbuild_trigger.devops_trigger.trigger_id
}
