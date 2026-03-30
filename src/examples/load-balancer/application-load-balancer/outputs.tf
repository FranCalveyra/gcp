output "load_balancer_ipv4" {
  description = "IPv4 pública del Application Load Balancer."
  value       = google_compute_global_address.ipv4.address
}

output "load_balancer_ipv6" {
  description = "IPv6 pública del Application Load Balancer (si está habilitada)."
  value       = try(google_compute_global_forwarding_rule.http_ipv6[0].ip_address, null)
}

output "backend_instance_groups" {
  description = "Instance groups creados para los backends."
  value       = { for k, v in google_compute_instance_group_manager.mig : k => v.instance_group }
}

output "autoscalers" {
  description = "Autoscalers asociados a cada MIG."
  value       = { for k, v in google_compute_autoscaler.mig : k => v.name }
}
