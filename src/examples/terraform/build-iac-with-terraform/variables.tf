variable "project_id" {
  description = "GCP project ID donde se despliega la práctica."
  type        = string
}

variable "region" {
  description = "Región principal para recursos regionales."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona para las Compute Engine instances."
  type        = string
  default     = "us-central1-a"
}

variable "bucket_name" {
  description = "Nombre del bucket para simular backend/state remoto."
  type        = string
}

variable "network_name" {
  description = "Nombre de la VPC creada con módulo del registry."
  type        = string
  default     = "terraform-vpc"
}

variable "subnet_01_cidr" {
  description = "Rango CIDR de subnet-01."
  type        = string
  default     = "10.10.10.0/24"
}

variable "subnet_02_cidr" {
  description = "Rango CIDR de subnet-02."
  type        = string
  default     = "10.10.20.0/24"
}

variable "machine_type" {
  description = "Machine type para las instancias principales."
  type        = string
  default     = "e2-standard-2"
}

variable "create_third_instance" {
  description = "Si true, crea una tercera instancia para practicar taint/recreate/remove."
  type        = bool
  default     = false
}

variable "third_instance_name" {
  description = "Nombre de la tercera instancia opcional."
  type        = string
  default     = "tf-instance-3"
}

variable "labels" {
  description = "Labels comunes para recursos."
  type        = map(string)
  default = {
    managed-by = "terraform"
    example    = "build-iac-with-terraform"
  }
}
