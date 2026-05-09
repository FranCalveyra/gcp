variable "project_id" {
  description = "ID del proyecto de GCP."
  type        = string
}

variable "region" {
  description = "Región principal para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona para las VMs del escenario."
  type        = string
  default     = "us-central1-b"
}

variable "network_name" {
  description = "Nombre de la VPC principal."
  type        = string
  default     = "acme-vpc"
}

variable "web_subnet_name" {
  description = "Nombre de la subnet web."
  type        = string
  default     = "acme-web-subnet"
}

variable "web_subnet_cidr" {
  description = "CIDR de la subnet web."
  type        = string
  default     = "192.168.20.0/24"
}

variable "mgmt_subnet_name" {
  description = "Nombre de la subnet de gestión."
  type        = string
  default     = "acme-mgmt-subnet"
}

variable "mgmt_subnet_cidr" {
  description = "CIDR de la subnet de gestión."
  type        = string
  default     = "192.168.10.0/24"
}

variable "bastion_name" {
  description = "Nombre de la VM bastion."
  type        = string
  default     = "bastion"
}

variable "juice_shop_name" {
  description = "Nombre de la VM juice-shop."
  type        = string
  default     = "juice-shop"
}

variable "machine_type" {
  description = "Tipo de máquina para ambas VMs."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base para las instancias."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "ssh_iap_network_tag" {
  description = "Tag para habilitar SSH a bastion solo vía IAP."
  type        = string
  default     = "ssh-iap"
}

variable "http_network_tag" {
  description = "Tag para habilitar HTTP público a juice-shop."
  type        = string
  default     = "http-server"
}

variable "ssh_internal_network_tag" {
  description = "Tag para habilitar SSH interno a juice-shop."
  type        = string
  default     = "ssh-internal"
}

variable "labels" {
  description = "Labels comunes para recursos."
  type        = map(string)
  default = {
    environment = "lab"
    managed_by  = "terraform"
  }
}
