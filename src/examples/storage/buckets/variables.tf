variable "project_id" {
  description = "GCP project ID donde se crean recursos."
  type        = string
}

variable "region" {
  description = "Región del bucket."
  type        = string
  default     = "us-central1"
}

variable "bucket_name_prefix" {
  description = "Prefijo para generar nombre globally-unique del bucket."
  type        = string
  default     = "cloud-storage-lab"
}

variable "enable_versioning" {
  description = "Habilita versionado de objetos en el bucket."
  type        = bool
  default     = true
}

variable "lifecycle_delete_age_days" {
  description = "Días de antigüedad para borrar objetos por lifecycle rule."
  type        = number
  default     = 31
}

variable "upload_sample_objects" {
  description = "Si sube objetos de ejemplo al bucket."
  type        = bool
  default     = true
}

variable "make_sample_public" {
  description = "Si hace público setup.html por IAM (equivalente funcional al ACL público del lab)."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "cloud-storage-lab"
  }
}
