variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región para Cloud Run y Vertex AI."
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "Nombre del servicio Cloud Run deployado desde Vertex AI Studio."
  type        = string
  default     = "insurance-risk-summary"
}

variable "allow_unauthenticated" {
  description = "Si permite acceso no autenticado al servicio Cloud Run (equivalente al deploy desde Studio)."
  type        = bool
  default     = true
}

variable "enable_tts_api" {
  description = "Si habilita Cloud Text-to-Speech API (tarea 5 opcional)."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "vertex-ai-studio"
  }
}
