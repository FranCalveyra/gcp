variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region para Cloud Run Functions y recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "enabled_services" {
  description = "APIs requeridas por el lab."
  type        = set(string)
  default = [
    "artifactregistry.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "eventarc.googleapis.com",
    "run.googleapis.com",
    "logging.googleapis.com",
    "pubsub.googleapis.com",
    "storage.googleapis.com",
  ]
}

variable "source_bucket_name" {
  description = "Bucket GCS que almacena los artefactos ZIP del codigo fuente de las funciones."
  type        = string
}

variable "source_objects" {
  description = "Mapa de objetos ZIP en source_bucket_name, uno por funcion."
  type        = map(string)
  default = {
    nodejs_http              = "nodejs-http-function.zip"
    nodejs_storage           = "nodejs-storage-function.zip"
    gce_vm_labeler           = "gce-vm-labeler.zip"
    hello_world_colored      = "hello-world-colored.zip"
    slow_function            = "slow-function.zip"
    slow_concurrent_function = "slow-concurrent-function.zip"
  }
}

variable "event_bucket_name" {
  description = "Nombre del bucket de eventos para la funcion de Cloud Storage. Si es null, usa gcf-gen2-storage-<project_id>."
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "cloud-run-functions-qwik-start"
  }
}
