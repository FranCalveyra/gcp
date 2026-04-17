output "custom_role_name" {
  description = "Nombre completo del rol custom creado en el proyecto."
  value       = google_project_iam_custom_role.devops.name
}

output "service_account_email" {
  description = "Email de la service account usada por la VM del ejemplo."
  value       = google_service_account.devops.email
}

output "user2_member" {
  description = "Principal al que se asignan los roles inspirados en el lab."
  value       = "user:${var.user2_email}"
}

output "user2_roles" {
  description = "Roles asignados al usuario secundario."
  value = sort(concat(
    [for role in google_project_iam_member.user_roles : role.role],
    [google_project_iam_member.user_devops.role],
  ))
}

output "vm_name" {
  description = "Nombre de la VM creada con la service account adjunta."
  value       = google_compute_instance.lab_3.name
}

output "vm_external_ip" {
  description = "IP externa de la VM `lab-3`."
  value       = google_compute_instance.lab_3.network_interface[0].access_config[0].nat_ip
}
