variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región principal del ejemplo."
  type        = string
  default     = "us-central1"
}

variable "zone_1" {
  description = "Zona para la VM `mynet-vm-1`."
  type        = string
  default     = "us-central1-a"
}

variable "zone_2" {
  description = "Zona para la VM `mynet-vm-2`."
  type        = string
  default     = "us-central1-b"
}

variable "network_name" {
  description = "Nombre de la VPC auto mode creada por el ejemplo."
  type        = string
  default     = "mynetwork"
}

variable "machine_type" {
  description = "Tipo de máquina para las VMs del lab."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base usada por las VMs."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "ssh_source_cidr" {
  description = "CIDR autorizado para SSH, idealmente la IP pública de Cloud Shell en formato /32."
  type        = string
}

variable "ssh_tag" {
  description = "Tag de red que reciben las VMs para asociar la regla SSH."
  type        = string
  default     = "lab-ssh"
}

variable "internal_icmp_source_range" {
  description = "Rango interno permitido para ICMP dentro de la VPC auto mode."
  type        = string
  default     = "10.128.0.0/9"
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "configuring-vpc"
  }
}
