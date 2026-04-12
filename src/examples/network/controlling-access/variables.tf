variable "project_id" {
  description = "GCP project ID donde se crean o consultan los recursos."
  type        = string
}

variable "region" {
  description = "Región usada para consultar la subred y ubicar las VMs."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona donde se crean las VMs del ejemplo."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Nombre de la VPC existente usada por el lab."
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "Nombre de la subred existente donde se crean las VMs."
  type        = string
  default     = "default"
}

variable "machine_type" {
  description = "Tipo de máquina de las VMs."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base usada por las VMs."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "web_server_tag" {
  description = "Tag de red aplicado al servidor que debe recibir tráfico HTTP externo."
  type        = string
  default     = "web-server"
}

variable "service_account_name" {
  description = "Account ID de la service account usada para probar permisos desde test-vm."
  type        = string
  default     = "network-admin"
}

variable "grant_security_admin" {
  description = "Si es true, además del rol Network Admin también otorga Security Admin para permitir borrar firewall rules."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "controlling-access"
  }
}
