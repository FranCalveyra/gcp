output "cluster_name" {
  description = "Nombre del cluster GKE creado."
  value       = google_container_cluster.cloud_trace_demo.name
}

output "cluster_location" {
  description = "Zona del cluster GKE."
  value       = google_container_cluster.cloud_trace_demo.location
}

output "get_credentials_command" {
  description = "Comando para configurar kubectl con el cluster."
  value       = "gcloud container clusters get-credentials ${google_container_cluster.cloud_trace_demo.name} --zone ${google_container_cluster.cloud_trace_demo.location} --project ${var.project_id}"
}
