output "network_name" {
  description = "Nombre de la VPC creada."
  value       = google_compute_network.acme_vpc.name
}

output "bastion_name" {
  description = "Nombre de la VM bastion."
  value       = google_compute_instance.bastion.name
}

output "bastion_internal_ip" {
  description = "IP interna de la VM bastion."
  value       = google_compute_instance.bastion.network_interface[0].network_ip
}

output "juice_shop_name" {
  description = "Nombre de la VM juice-shop."
  value       = google_compute_instance.juice_shop.name
}

output "juice_shop_internal_ip" {
  description = "IP interna de la VM juice-shop."
  value       = google_compute_instance.juice_shop.network_interface[0].network_ip
}

output "juice_shop_external_ip" {
  description = "IP externa de la VM juice-shop."
  value       = google_compute_instance.juice_shop.network_interface[0].access_config[0].nat_ip
}

output "firewall_rule_names" {
  description = "Reglas de firewall del escenario."
  value = [
    google_compute_firewall.allow_ssh_iap_ingress.name,
    google_compute_firewall.allow_http_ingress.name,
    google_compute_firewall.allow_ssh_internal_ingress.name,
  ]
}
