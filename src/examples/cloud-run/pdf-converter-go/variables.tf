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
    "cloudbuild.googleapis.com",
    "storage.googleapis.com",
    "pubsub.googleapis.com",
  ]
}

variable "pdf_converter_image" {
  description = "Imagen del servicio pdf-converter. Debe ser pre-construida con Cloud Build desde Deleplace/pet-theory lab03."
  type        = string
}

variable "upload_bucket_suffix" {
  description = "Sufijo del bucket de upload (nombre completo: PROJECT_ID-sufijo)."
  type        = string
  default     = "upload"
}

variable "processed_bucket_suffix" {
  description = "Sufijo del bucket de PDFs procesados (nombre completo: PROJECT_ID-sufijo)."
  type        = string
  default     = "processed"
}

variable "pubsub_topic_name" {
  description = "Nombre del topic de Pub/Sub que recibe notificaciones de GCS."
  type        = string
  default     = "new-doc"
}

variable "subscription_name" {
  description = "Nombre de la suscripcion push hacia pdf-converter."
  type        = string
  default     = "pdf-conv-sub"
}

variable "invoker_sa_id" {
  description = "Account ID de la service account usada por Pub/Sub para invocar Cloud Run."
  type        = string
  default     = "pubsub-cloud-run-invoker"
}

variable "cloud_run_service_name" {
  description = "Nombre del servicio Cloud Run."
  type        = string
  default     = "pdf-converter"
}

variable "cloud_run_memory" {
  description = "Limite de memoria para el contenedor (LibreOffice requiere al menos 2Gi)."
  type        = string
  default     = "2Gi"
}

variable "max_instances" {
  description = "Numero maximo de instancias del servicio Cloud Run."
  type        = number
  default     = 3
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "pdf-converter-go"
  }
}
