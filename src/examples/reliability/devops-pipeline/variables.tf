variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Region para Artifact Registry y Cloud Build."
  type        = string
  default     = "us-central1"
}

variable "enabled_services" {
  description = "APIs necesarias para el ejemplo."
  type        = set(string)
  default = [
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
}

variable "artifact_registry_repo_id" {
  description = "ID del repositorio de Artifact Registry."
  type        = string
  default     = "devops-repo"
}

variable "image_name" {
  description = "Nombre de la imagen Docker dentro del repositorio."
  type        = string
  default     = "devops-image"
}

variable "github_owner" {
  description = "Nombre de usuario u organizacion duena del repositorio GitHub."
  type        = string
}

variable "github_repo_name" {
  description = "Nombre del repositorio GitHub conectado al trigger."
  type        = string
  default     = "devops-repo"
}

variable "trigger_name" {
  description = "Nombre del Cloud Build trigger."
  type        = string
  default     = "devops-trigger"
}

variable "branch_pattern" {
  description = "Patron de rama que activa el build (regex)."
  type        = string
  default     = "^main$"
}

variable "labels" {
  description = "Labels comunes para los recursos que las soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "devops-pipeline"
  }
}
