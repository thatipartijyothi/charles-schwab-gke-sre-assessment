variable "project_id" {
  description = "Existing GCP project ID with billing enabled."
  type        = string
}

variable "primary_region" {
  type    = string
  default = "us-central1"
}

variable "secondary_region" {
  type    = string
  default = "us-east1"
}

variable "primary_zone" {
  description = "Zonal control plane reduces assessment cost; use a region in production."
  type        = string
  default     = "us-central1-a"
}

variable "secondary_zone" {
  type    = string
  default = "us-east1-b"
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "nodes_per_cluster" {
  type    = number
  default = 1

  validation {
    condition     = var.nodes_per_cluster >= 1 && var.nodes_per_cluster <= 5
    error_message = "nodes_per_cluster must be between 1 and 5."
  }
}

variable "labels" {
  type = map(string)
  default = {
    environment = "assessment"
    owner       = "jyothi-thatiparti"
    managed-by  = "terraform"
  }
}

