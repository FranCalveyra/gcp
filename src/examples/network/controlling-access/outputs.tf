output "firewall_rule_name" {
  description = "Nombre de la firewall rule creada para el servidor taggeado."
  value       = google_compute_firewall.allow_http_web_server.name
}

output "service_account_email" {
  description = "Email de la service account asociada a test-vm."
  value       = google_service_account.network_admin.email
}

output "web_server_internal_ips" {
  description = "IPs internas de blue y green."
  value = {
    for name, vm in google_compute_instance.web :
    name => vm.network_interface[0].network_ip
  }
}

output "web_server_external_ips" {
  description = "IPs externas de blue y green."
  value = {
    for name, vm in google_compute_instance.web :
    name => vm.network_interface[0].access_config[0].nat_ip
  }
}

output "test_vm_external_ip" {
  description = "IP externa de la VM usada para las pruebas."
  value       = google_compute_instance.test_vm.network_interface[0].access_config[0].nat_ip
}
