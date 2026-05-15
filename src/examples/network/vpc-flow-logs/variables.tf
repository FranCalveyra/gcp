variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "region" {
  description = "Región donde se despliega la subred y la VM."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona donde se crea la VM web-server."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Nombre de la VPC custom mode."
  type        = string
  default     = "vpc-net"
}

variable "subnet_name" {
  description = "Nombre de la subred con Flow Logs habilitados."
  type        = string
  default     = "vpc-subnet"
}

variable "subnet_cidr" {
  description = "Rango CIDR de la subred."
  type        = string
  default     = "10.1.3.0/24"
}

variable "flow_logs_interval" {
  description = "Intervalo de agregación de VPC Flow Logs."
  type        = string
  default     = "INTERVAL_5_SEC"
}

variable "flow_logs_sampling" {
  description = "Tasa de muestreo de Flow Logs (0.0–1.0)."
  type        = number
  default     = 0.5
}

variable "machine_type" {
  description = "Tipo de máquina para la VM web-server."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base de la VM."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "http_server_tag" {
  description = "Tag de red que identifica la VM web-server."
  type        = string
  default     = "http-server"
}

variable "bq_dataset_id" {
  description = "ID del dataset de BigQuery que recibe los Flow Logs."
  type        = string
  default     = "bq_vpcflows"
}

variable "log_sink_name" {
  description = "Nombre del log sink de Cloud Logging."
  type        = string
  default     = "vpc-flows"
}

variable "labels" {
  description = "Labels comunes para los recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "vpc-flow-logs"
  }
}
