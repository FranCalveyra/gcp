variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región de la VM."
  type        = string
  default     = "us-east4"
}

variable "zone" {
  description = "Zona de la VM."
  type        = string
  default     = "us-east4-c"
}

variable "instance_name" {
  description = "Nombre de la VM."
  type        = string
  default     = "quickstart-vm"
}

variable "machine_type" {
  description = "Tipo de máquina para la VM."
  type        = string
  default     = "e2-small"
}

variable "instance_image" {
  description = "Imagen base de la VM."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "http_server_tag" {
  description = "Tag de red para la VM y la regla de firewall HTTP."
  type        = string
  default     = "http-server"
}

variable "alert_notification_email" {
  description = "Email para el canal de notificación del alerting policy. Dejar vacío para no crear el canal."
  type        = string
  default     = ""
}

variable "apache_traffic_threshold_kbps" {
  description = "Umbral de tráfico Apache (KiB/s) que dispara la alerta."
  type        = number
  default     = 4000
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "ops-agent-monitoring"
  }
}
