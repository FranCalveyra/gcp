variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region_1" {
  description = "Región principal para managementnet, privatesubnet-1 y la primera subred automática de mynetwork."
  type        = string
  default     = "us-central1"
}

variable "region_2" {
  description = "Segunda región usada por privatesubnet-2 y mynet-vm-2."
  type        = string
  default     = "us-east1"
}

variable "zone_1" {
  description = "Zona para managementnet-vm-1, privatenet-vm-1, mynet-vm-1 y vm-appliance."
  type        = string
  default     = "us-central1-a"
}

variable "zone_2" {
  description = "Zona para mynet-vm-2."
  type        = string
  default     = "us-east1-b"
}

variable "managementnet_name" {
  description = "Nombre de la red de management."
  type        = string
  default     = "managementnet"
}

variable "privatenet_name" {
  description = "Nombre de la red privada."
  type        = string
  default     = "privatenet"
}

variable "mynetwork_name" {
  description = "Nombre de la red auto mode usada como tercera red del laboratorio."
  type        = string
  default     = "mynetwork"
}

variable "management_subnet_cidr" {
  description = "CIDR de managementsubnet-1."
  type        = string
  default     = "10.130.0.0/20"
}

variable "private_subnet_1_cidr" {
  description = "CIDR de privatesubnet-1."
  type        = string
  default     = "172.16.0.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR de privatesubnet-2."
  type        = string
  default     = "172.20.0.0/20"
}

variable "mynet_internal_source_range" {
  description = "Rango interno permitido para ICMP dentro de mynetwork."
  type        = string
  default     = "10.128.0.0/9"
}

variable "standard_machine_type" {
  description = "Tipo de máquina para VMs simples."
  type        = string
  default     = "e2-micro"
}

variable "appliance_machine_type" {
  description = "Tipo de máquina para la VM con múltiples interfaces."
  type        = string
  default     = "e2-standard-4"
}

variable "instance_image" {
  description = "Imagen base usada por las VMs."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "multiple-vpc"
  }
}
