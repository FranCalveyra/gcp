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

variable "store_service_name" {
  description = "Nombre del servicio Cloud Run publico (productor)."
  type        = string
  default     = "store-service"
}

variable "order_service_name" {
  description = "Nombre del servicio Cloud Run privado (consumidor)."
  type        = string
  default     = "order-service"
}

variable "store_service_image" {
  description = "Imagen del servicio store."
  type        = string
  default     = "gcr.io/qwiklabs-resources/gsp724-store-service"
}

variable "order_service_image" {
  description = "Imagen del servicio order."
  type        = string
  default     = "gcr.io/qwiklabs-resources/gsp724-order-service"
}

variable "topic_name" {
  description = "Nombre del topic de Pub/Sub."
  type        = string
  default     = "ORDER_PLACED"
}

variable "subscription_name" {
  description = "Nombre de la suscripcion push."
  type        = string
  default     = "order-service-sub"
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
    example    = "pubsub-with-cloud-run"
  }
}
