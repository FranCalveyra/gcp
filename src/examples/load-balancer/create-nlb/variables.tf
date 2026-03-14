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
  description = "GCP zone for compute instances."
  type        = string
  default     = "us-central1-c"
}

variable "network_name" {
  description = "VPC network name used by instances and firewall."
  type        = string
  default     = "default"
}

variable "instance_names" {
  description = "Names of web instances behind the target pool."
  type        = list(string)
  default     = ["www1", "www2", "www3"]

  validation {
    condition     = length(var.instance_names) > 0
    error_message = "Provide at least one instance name."
  }
}

variable "instance_machine_type" {
  description = "Machine type for each web instance."
  type        = string
  default     = "e2-small"
}

variable "instance_network_tag" {
  description = "Network tag applied to instances and used by firewall targeting."
  type        = string
  default     = "network-lb-tag"
}

variable "instance_image_family" {
  description = "Image family for VM boot disk."
  type        = string
  default     = "debian-11"
}

variable "instance_image_project" {
  description = "Image project for VM boot disk."
  type        = string
  default     = "debian-cloud"
}

variable "http_port" {
  description = "HTTP port exposed by instances and load balancer."
  type        = number
  default     = 80
}

variable "firewall_rule_name" {
  description = "Name of firewall rule that allows traffic to instances."
  type        = string
  default     = "www-firewall-network-lb"
}

variable "health_check_name" {
  description = "Name of HTTP health check resource."
  type        = string
  default     = "basic-check"
}

variable "target_pool_name" {
  description = "Name of target pool used by the NLB."
  type        = string
  default     = "www-pool"
}

variable "forwarding_rule_name" {
  description = "Name of forwarding rule for the NLB."
  type        = string
  default     = "www-rule"
}

variable "forwarding_rule_address_name" {
  description = "Name of reserved regional address used by the forwarding rule."
  type        = string
  default     = "network-lb-ip-1"
}
