variable "project_id" {
  description = "ID del proyecto de GCP donde se despliegan los recursos."
  type        = string
}

variable "region" {
  description = "Región principal para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Zonas para desplegar las dos VMs."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "network_name" {
  description = "Nombre de la VPC auto mode."
  type        = string
  default     = "mynetwork"
}

variable "firewall_name" {
  description = "Nombre de la regla firewall del lab."
  type        = string
  default     = "mynetwork-allow-http-ssh-rdp-icmp"
}

variable "machine_type" {
  description = "Tipo de máquina para las VMs."
  type        = string
  default     = "e2-micro"
}

variable "vm_image" {
  description = "Imagen base para las VMs."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "vm_names" {
  description = "Nombres de VMs a crear."
  type        = list(string)
  default     = ["mynet-vm-1", "mynet-vm-2"]
}
