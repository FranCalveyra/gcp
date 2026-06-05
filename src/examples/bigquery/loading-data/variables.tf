variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región por defecto del dataset de BigQuery."
  type        = string
  default     = "US"
}

variable "dataset_id" {
  description = "ID del dataset de BigQuery."
  type        = string
  default     = "nyctaxi"
}

variable "gcs_source_uri" {
  description = "URI de GCS del CSV con datos de NYC Taxi (subset 2)."
  type        = string
  default     = "gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv"
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "bigquery-loading-data"
  }
}
