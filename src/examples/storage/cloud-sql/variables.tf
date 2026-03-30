variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región principal para Cloud SQL y recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona para las VMs de prueba."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Nombre de la VPC a usar."
  type        = string
  default     = "default"
}

variable "sql_instance_name" {
  description = "Nombre de la instancia Cloud SQL."
  type        = string
  default     = "wordpress-db"
}

variable "sql_database_version" {
  description = "Versión del motor Cloud SQL."
  type        = string
  default     = "MYSQL_8_0"
}

variable "sql_tier" {
  description = "Tier de la instancia Cloud SQL."
  type        = string
  default     = "db-custom-1-3840"
}

variable "sql_root_password" {
  description = "Password del usuario root de Cloud SQL."
  type        = string
  sensitive   = true
}

variable "wordpress_database_name" {
  description = "Nombre de la base de datos que usa WordPress."
  type        = string
  default     = "wordpress"
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "cloud-sql-lab"
  }
}
