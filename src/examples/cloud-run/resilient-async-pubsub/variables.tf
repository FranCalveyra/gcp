variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "enabled_services" {
  description = "APIs necesarias para el ejemplo."
  type        = set(string)
  default = [
    "run.googleapis.com",
    "pubsub.googleapis.com",
    "iam.googleapis.com",
  ]
}

variable "lab_report_service_name" {
  description = "Nombre del servicio Cloud Run publico (productor)."
  type        = string
  default     = "lab-report-service"
}

variable "email_service_name" {
  description = "Nombre del servicio Cloud Run privado para notificaciones email."
  type        = string
  default     = "email-service"
}

variable "sms_service_name" {
  description = "Nombre del servicio Cloud Run privado para notificaciones SMS."
  type        = string
  default     = "sms-service"
}

variable "lab_report_service_image" {
  description = "Imagen del servicio lab-report-service. Debe ser pre-construida desde pet-theory."
  type        = string
}

variable "email_service_image" {
  description = "Imagen del servicio email-service. Debe ser pre-construida desde pet-theory."
  type        = string
}

variable "sms_service_image" {
  description = "Imagen del servicio sms-service. Debe ser pre-construida desde pet-theory."
  type        = string
}

variable "topic_name" {
  description = "Nombre del topic de Pub/Sub."
  type        = string
  default     = "new-lab-report"
}

variable "invoker_service_account_id" {
  description = "Account ID de la service account usada por Pub/Sub para invocar Cloud Run."
  type        = string
  default     = "pubsub-cloud-run-invoker"
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "resilient-async-pubsub"
  }
}
