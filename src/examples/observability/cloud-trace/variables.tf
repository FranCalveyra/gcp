variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región del cluster GKE."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona del cluster GKE."
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "Nombre del cluster GKE."
  type        = string
  default     = "cloud-trace-demo"
}

variable "node_count" {
  description = "Cantidad de nodos en el node pool por defecto."
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Tipo de máquina para los nodos del cluster."
  type        = string
  default     = "e2-medium"
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "cloud-trace"
  }
}
