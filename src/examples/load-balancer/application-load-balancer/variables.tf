variable "project_id" {
  description = "GCP project ID donde se crean los recursos."
  type        = string
}

variable "default_region" {
  description = "Región por defecto del provider."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Nombre de la VPC."
  type        = string
  default     = "default"
}

variable "backend_groups" {
  description = "Backends zonales para los managed instance groups."
  type = map(object({
    region       = string
    zone         = string
    name         = string
    target_size  = number
    min_replicas = number
    max_replicas = number
  }))
  default = {
    us = {
      region       = "us-central1"
      zone         = "us-central1-a"
      name         = "us-central1-mig"
      target_size  = 1
      min_replicas = 1
      max_replicas = 5
    }
    eu = {
      region       = "europe-west1"
      zone         = "europe-west1-b"
      name         = "europe-west1-mig"
      target_size  = 1
      min_replicas = 1
      max_replicas = 5
    }
  }
}

variable "instance_template_name" {
  description = "Nombre del instance template."
  type        = string
  default     = "mywebserver-template"
}

variable "machine_type" {
  description = "Machine type para instancias de backend."
  type        = string
  default     = "e2-micro"
}

variable "instance_image" {
  description = "Imagen base para instancias del backend."
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "enable_ipv6" {
  description = "Si se crea forwarding rule IPv6 adicional."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels comunes para recursos que los soportan."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "application-load-balancer-autoscaling"
  }
}
