output "instance_name" {
  description = "Nombre de la VM creada."
  value       = google_compute_instance.quickstart_vm.name
}

output "instance_external_ip" {
  description = "IP externa de la VM para acceder al servidor Apache."
  value       = google_compute_instance.quickstart_vm.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "Comando para conectarse a la VM por SSH."
  value       = "gcloud compute ssh --zone ${var.zone} ${var.instance_name} --project ${var.project_id}"
}

output "alert_policy_name" {
  description = "Nombre del alerting policy creado (vacío si no se configuró email)."
  value       = length(google_monitoring_alert_policy.apache_traffic) > 0 ? google_monitoring_alert_policy.apache_traffic[0].display_name : ""
}
