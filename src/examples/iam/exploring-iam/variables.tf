variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region principal del ejemplo."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona donde se crea la VM `demoiam`."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Nombre de la red VPC existente donde se conecta la VM."
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "Nombre de la subred existente asociada a `region`."
  type        = string
  default     = "default"
}

variable "bucket_name_prefix" {
  description = "Prefijo para generar un bucket globally unique."
  type        = string
  default     = "exploring-iam"
}

variable "bucket_location" {
  description = "Ubicacion del bucket. `US` replica el bucket multi-region del lab."
  type        = string
  default     = "US"
}

variable "sample_object_name" {
  description = "Nombre del objeto de prueba cargado al bucket."
  type        = string
  default     = "sample.txt"
}

variable "sample_object_content" {
  description = "Contenido del archivo de prueba subido por Terraform."
  type        = string
  default     = "Exploring IAM sample object managed by Terraform.\n"
}

variable "service_account_id" {
  description = "Account ID del service account adjunto a la VM."
  type        = string
  default     = "read-bucket-objects"
}

variable "vm_name" {
  description = "Nombre de la instancia de Compute Engine."
  type        = string
  default     = "demoiam"
}

variable "machine_type" {
  description = "Tipo de maquina para la VM del lab."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base para la VM."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "limited_storage_member" {
  description = "Principal IAM opcional en formato `user:`, `group:` o `serviceAccount:` para acceso restringido al bucket."
  type        = string
  default     = null
}

variable "service_account_user_member" {
  description = "Principal IAM opcional que recibe `roles/iam.serviceAccountUser` sobre el service account."
  type        = string
  default     = null
}

variable "compute_instance_admin_member" {
  description = "Principal IAM opcional que recibe `roles/compute.instanceAdmin.v1` a nivel proyecto."
  type        = string
  default     = null
}

variable "service_account_bucket_roles" {
  description = "Roles sobre el bucket para el service account de la VM."
  type        = set(string)
  default = [
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
  ]
}

variable "enabled_services" {
  description = "APIs que el ejemplo habilita de forma declarativa."
  type        = set(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
  ]
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "exploring-iam"
  }
}
