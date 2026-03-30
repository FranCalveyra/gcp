output "sql_instance_connection_name" {
  description = "Connection name de la instancia Cloud SQL."
  value       = google_sql_database_instance.wordpress_db.connection_name
}

output "sql_private_ip" {
  description = "IP privada de la instancia Cloud SQL."
  value       = google_sql_database_instance.wordpress_db.private_ip_address
}

output "sql_public_ip" {
  description = "IP pública de la instancia Cloud SQL (si está habilitada)."
  value       = google_sql_database_instance.wordpress_db.public_ip_address
}

output "wordpress_proxy_external_ip" {
  description = "IP externa de la VM wordpress-proxy."
  value       = google_compute_instance.wordpress_proxy.network_interface[0].access_config[0].nat_ip
}

output "wordpress_private_ip_external_ip" {
  description = "IP externa de la VM wordpress-private-ip."
  value       = google_compute_instance.wordpress_private_ip.network_interface[0].access_config[0].nat_ip
}
