variable "project_id" {
  description = "Project ID donde se reproduce el escenario IAM del lab."
  type        = string
}

variable "user2_email" {
  description = "Email del usuario secundario al que se le asignan los roles viewer, iam.serviceAccountUser y el rol custom."
  type        = string
}

variable "region" {
  description = "Region donde existe la subred usada por la VM del ejemplo."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona donde se crea la VM `lab-3`."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Nombre de la VPC existente usada por el ejemplo."
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "Nombre de la subred existente usada por la VM."
  type        = string
  default     = "default"
}

variable "machine_type" {
  description = "Tipo de maquina de la VM creada para probar la service account."
  type        = string
  default     = "e2-standard-2"
}

variable "instance_name" {
  description = "Nombre de la VM que queda adjunta a la service account del escenario."
  type        = string
  default     = "lab-3"
}

variable "instance_image" {
  description = "Imagen base usada para crear la VM."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "instance_tags" {
  description = "Tags de red opcionales para la VM."
  type        = list(string)
  default     = []
}

variable "custom_role_id" {
  description = "Role ID del rol custom del proyecto. Debe ser camelCase o sin guiones."
  type        = string
  default     = "devops"
}

variable "custom_role_title" {
  description = "Titulo visible del rol custom."
  type        = string
  default     = "DevOps"
}

variable "service_account_id" {
  description = "Account ID de la service account creada para el escenario."
  type        = string
  default     = "devops"
}

variable "service_account_display_name" {
  description = "Display name de la service account."
  type        = string
  default     = "devops"
}

variable "service_account_scopes" {
  description = "Scopes OAuth asociados a la VM que usa la service account."
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "labels" {
  description = "Labels comunes para los recursos que soportan labels."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "configuring-iam-with-gcloud"
    topic      = "iam"
  }
}
