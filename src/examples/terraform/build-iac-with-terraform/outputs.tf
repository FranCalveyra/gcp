output "bucket_name" {
  description = "Nombre del bucket creado para state/backend remoto."
  value       = google_storage_bucket.tf_state.name
}

output "vpc_name" {
  description = "Nombre de la VPC creada con módulo del registry."
  value       = module.vpc.network_name
}

output "subnet_names" {
  description = "Subnets creadas para conectar las VMs."
  value       = [local.subnet_01_name, local.subnet_02_name]
}

output "instance_names" {
  description = "Nombres de instancias principales gestionadas."
  value = [
    google_compute_instance.tf_instance_1.name,
    google_compute_instance.tf_instance_2.name,
  ]
}

output "third_instance_name" {
  description = "Nombre de la tercera instancia cuando está habilitada."
  value       = var.create_third_instance ? google_compute_instance.tf_instance_3[0].name : null
}

output "service_account_email" {
  description = "Service account asignada a las VMs de la práctica."
  value       = google_service_account.lab_vm_sa.email
}
