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
    "cloudbuild.googleapis.com",
    "storage.googleapis.com",
  ]
}

variable "pdf_converter_image" {
  description = "Imagen del servicio pdf-converter. Debe construirse antes con 'gcloud builds submit --tag gcr.io/<project>/pdf-converter'."
  type        = string
}

variable "cloud_run_service_name" {
  description = "Nombre del servicio Cloud Run."
  type        = string
  default     = "pdf-converter"
}

variable "cloud_run_memory" {
  description = "Memoria asignada al servicio. LibreOffice requiere al menos 2Gi."
  type        = string
  default     = "2Gi"
}

variable "upload_bucket_suffix" {
  description = "Sufijo del bucket de upload. El nombre final sera '<project_id>-<sufijo>'."
  type        = string
  default     = "upload"
}

variable "processed_bucket_suffix" {
  description = "Sufijo del bucket de procesados. El nombre final sera '<project_id>-<sufijo>'."
  type        = string
  default     = "processed"
}

variable "pubsub_topic_name" {
  description = "Nombre del topic de Pub/Sub que recibe las notificaciones de Cloud Storage."
  type        = string
  default     = "new-doc"
}

variable "subscription_name" {
  description = "Nombre de la suscripcion push hacia Cloud Run."
  type        = string
  default     = "pdf-conv-sub"
}

variable "invoker_sa_id" {
  description = "Account ID de la service account que Pub/Sub usa para invocar Cloud Run."
  type        = string
  default     = "pubsub-cloud-run-invoker"
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "pdf-converter"
  }
}
