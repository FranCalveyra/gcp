output "instance_name" {
  description = "Name of the created Compute Engine instance."
  value       = google_compute_instance.default.name
}

output "internal_ip" {
  description = "Internal IP address of the instance."
  value       = google_compute_instance.default.network_interface[0].network_ip
}

output "external_ip" {
  description = "Ephemeral external IP address of the instance."
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
