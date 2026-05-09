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

variable "slo_goal" {
  description = "Objetivo del SLO de disponibilidad (0 < goal <= 0.999)."
  type        = number
  default     = 0.995
}

variable "slo_rolling_period_days" {
  description = "Ventana rolling del SLO (en días). En el lab se usa 7 días."
  type        = number
  default     = 7
}

variable "slo_id" {
  description = "ID del SLO dentro del servicio de Monitoring (si no se especifica, se usa uno derivado)."
  type        = string
  default     = null
}

variable "burn_rate_lookback_seconds" {
  description = "Lookback (en segundos) para calcular burn rate del error budget. En el lab se usa 10 minutos."
  type        = number
  default     = 600
}

variable "burn_rate_threshold" {
  description = "Threshold de burn rate para disparar la alerta. En el lab se usa 1.5."
  type        = number
  default     = 1.5
}

variable "notification_email" {
  description = "Email para crear un notification channel de Monitoring. Si es null, no se crea."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "service-monitoring"
  }
}

