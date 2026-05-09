output "network_name" {
  description = "Nombre de la VPC creada."
  value       = google_compute_network.mynetwork.name
}

output "network_self_link" {
  description = "Self link de la VPC."
  value       = google_compute_network.mynetwork.self_link
}

output "firewall_rule_name" {
  description = "Nombre de la regla firewall creada."
  value       = google_compute_firewall.allow_http_ssh_rdp_icmp.name
}

output "vm_self_links" {
  description = "Self links de las VMs desplegadas."
  value       = { for name, vm in google_compute_instance.vms : name => vm.self_link }
}

output "vm_external_ips" {
  description = "IPs externas efímeras asignadas a las VMs."
  value = {
    for name, vm in google_compute_instance.vms :
    name => vm.network_interface[0].access_config[0].nat_ip
  }
}
