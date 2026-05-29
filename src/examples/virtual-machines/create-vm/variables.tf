variable "project_id" {
  description = "GCP project ID where resources are created."
  type        = string
}

variable "region" {
  description = "GCP region for regional resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the instance."
  type        = string
  default     = "us-central1-c"
}

variable "instance_name" {
  description = "Name of the Compute Engine instance."
  type        = string
  default     = "my-vm"
}

variable "machine_type" {
  description = "Machine type for the instance."
  type        = string
  default     = "n1-standard-1"
}

variable "boot_image" {
  description = "Boot disk image for the instance."
  type        = string
  default     = "ubuntu-minimal-2210-kinetic-amd64-v20230126"
}

variable "network_name" {
  description = "VPC network used by the instance."
  type        = string
  default     = "default"
}
