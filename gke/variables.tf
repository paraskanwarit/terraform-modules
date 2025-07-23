variable "name" {
  description = "GKE Cluster name"
  type        = string
}

variable "region" {
  description = "Region for GKE cluster"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "ip_range_pods" {
  description = "Secondary range for pods"
  type        = string
}

variable "ip_range_services" {
  description = "Secondary range for services"
  type        = string
}
