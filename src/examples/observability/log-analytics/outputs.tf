output "cluster_name" {
  value       = google_container_cluster.day2_ops.name
  description = "Nombre del cluster GKE."
}

output "cluster_location" {
  value       = google_container_cluster.day2_ops.location
  description = "Location del cluster (región)."
}

output "log_bucket_name" {
  value       = google_logging_project_bucket_config.log_analytics.name
  description = "Nombre completo del log bucket."
}

output "log_bucket_destination" {
  value       = "logging.googleapis.com/projects/${var.project_id}/locations/${var.log_bucket_location}/buckets/${var.log_bucket_id}"
  description = "Destination string para sinks hacia este bucket."
}

output "linked_dataset_resource_name" {
  value       = google_logging_linked_dataset.log_analytics.name
  description = "Nombre del recurso de linked dataset (Logging)."
}

output "sink_name" {
  value       = google_logging_project_sink.k8s_to_bucket.name
  description = "Nombre del sink."
}

output "sink_writer_identity" {
  value       = google_logging_project_sink.k8s_to_bucket.writer_identity
  description = "Identidad del writer del sink (útil si exportás a otro proyecto)."
}

