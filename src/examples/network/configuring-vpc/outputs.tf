output "network_name" {
  description = "Nombre de la VPC creada."
  value       = google_compute_network.mynetwork.name
}

output "network_self_link" {
  description = "Self link de la VPC creada."
  value       = google_compute_network.mynetwork.self_link
}

output "vm_internal_ips" {
  description = "IPs internas de las VMs del ejemplo."
  value = {
    for name, vm in google_compute_instance.vms :
    name => vm.network_interface[0].network_ip
  }
}

output "vm_external_ips" {
  description = "IPs externas de las VMs del ejemplo."
  value = {
    for name, vm in google_compute_instance.vms :
    name => vm.network_interface[0].access_config[0].nat_ip
  }
}

output "firewall_rule_names" {
  description = "Nombres de las reglas de firewall creadas."
  value = [
    google_compute_firewall.allow_ssh_from_cloud_shell.name,
    google_compute_firewall.allow_icmp_internal.name,
    google_compute_firewall.deny_icmp_ingress.name,
    google_compute_firewall.deny_icmp_egress.name,
  ]
}
