variable "project_id" {
  type        = string
  description = "Project ID donde se crean los recursos."
}

variable "region" {
  type        = string
  description = "Región principal para recursos regionales (por ejemplo GKE)."
  default     = "us-west1"
}

variable "zone" {
  type        = string
  description = "Zona para el node pool (si aplica)."
  default     = "us-west1-a"
}

variable "enabled_services" {
  type        = set(string)
  description = "APIs a habilitar en el proyecto."
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
  ]
}

variable "cluster_name" {
  type        = string
  description = "Nombre del cluster GKE."
  default     = "day2-ops"
}

variable "node_pool_name" {
  type        = string
  description = "Nombre del node pool."
  default     = "primary"
}

variable "node_machine_type" {
  type        = string
  description = "Machine type para nodos del cluster."
  default     = "e2-standard-2"
}

variable "node_count" {
  type        = number
  description = "Cantidad de nodos (si autoscaling está desactivado)."
  default     = 3
}

variable "log_bucket_id" {
  type        = string
  description = "Bucket ID de Cloud Logging para Log Analytics."
  default     = "day2ops-log"
}

variable "log_bucket_location" {
  type        = string
  description = "Location del log bucket. En el lab se usa global."
  default     = "global"
}

variable "log_bucket_retention_days" {
  type        = number
  description = "Retención de logs en días."
  default     = 30
}

variable "linked_dataset_id" {
  type        = string
  description = "ID del dataset linkeado en BigQuery (link_id)."
  default     = "day2ops_log"
}

variable "sink_name" {
  type        = string
  description = "Nombre del log sink."
  default     = "day2ops-sink"
}

variable "sink_filter" {
  type        = string
  description = "Filtro del sink (se copia de Logs Explorer en el lab)."
  default     = "resource.type=\"k8s_container\""
}

variable "labels" {
  type        = map(string)
  description = "Labels para recursos que soporten user_labels."
  default = {
    course = "austral-gcp-2026"
    lab    = "log-analytics"
  }
}

