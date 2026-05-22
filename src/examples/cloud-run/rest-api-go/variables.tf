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
    "firestore.googleapis.com",
  ]
}

variable "rest_api_image" {
  description = "Imagen del servicio rest-api. Debe ser pre-construida con Cloud Build desde pet-theory/lab08."
  type        = string
}

variable "service_name" {
  description = "Nombre del servicio Cloud Run."
  type        = string
  default     = "rest-api"
}

variable "firestore_location" {
  description = "Ubicacion de la base de datos Firestore."
  type        = string
  default     = "nam5"
}

variable "max_instances" {
  description = "Numero maximo de instancias del servicio Cloud Run."
  type        = number
  default     = 2
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "rest-api-go"
  }
}
