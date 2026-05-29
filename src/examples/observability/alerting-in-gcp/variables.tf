variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region para recursos regionales (cuando aplique)."
  type        = string
  default     = "us-central1"
}

variable "app_engine_location_id" {
  description = "Location ID para App Engine application (por ejemplo: us-central, southamerica-east1). No es lo mismo que region."
  type        = string
  default     = "us-central"
}

variable "enabled_services" {
  description = "APIs necesarias para el ejemplo."
  type        = set(string)
  default = [
    "appengine.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

variable "notification_email" {
  description = "Email para crear un notification channel de Monitoring. Si es null, no se crea."
  type        = string
  default     = null
}

variable "latency_threshold_seconds" {
  description = "Umbral de latencia (en segundos) para el alert de App Engine."
  type        = number
  default     = 8
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "alerting-in-gcp"
  }
}

