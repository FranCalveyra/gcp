output "network_self_link" {
  description = "Self link de la VPC creada."
  value       = google_compute_network.vpc_net.self_link
}

output "subnet_self_link" {
  description = "Self link de la subred con Flow Logs."
  value       = google_compute_subnetwork.vpc_subnet.self_link
}

output "web_server_external_ip" {
  description = "IP externa de la VM web-server para generar tráfico de prueba."
  value       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
}

output "bigquery_dataset_id" {
  description = "ID del dataset de BigQuery que recibe los Flow Logs."
  value       = google_bigquery_dataset.bq_vpcflows.dataset_id
}

output "log_sink_name" {
  description = "Nombre del log sink creado."
  value       = google_logging_project_sink.vpc_flows.name
}

output "log_sink_writer_identity" {
  description = "Service account del sink; debe tener roles/bigquery.dataEditor sobre el dataset."
  value       = google_logging_project_sink.vpc_flows.writer_identity
}
