variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "app_engine_location_id" {
  description = "Location ID para App Engine (ej: us-central, southamerica-east1). Distinto de region."
  type        = string
  default     = "us-central"
}

variable "enabled_services" {
  description = "APIs necesarias para el ejemplo."
  type        = set(string)
  default = [
    "appengine.googleapis.com",
    "cloudprofiler.googleapis.com",
    "cloudtrace.googleapis.com",
    "monitoring.googleapis.com",
    "compute.googleapis.com",
  ]
}

variable "uptime_check_host" {
  description = "Host del uptime check (ej: <project-id>.appspot.com)."
  type        = string
}

variable "notification_email" {
  description = "Email para el notification channel de Monitoring. Si es null, no se crea."
  type        = string
  default     = null
}

variable "latency_threshold_seconds" {
  description = "Umbral de latencia (segundos) para el alert de App Engine."
  type        = number
  default     = 8
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "monitoring-apps-in-gcp"
  }
}
