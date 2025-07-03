variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

variable "database_version" {
  description = "The database engine type and version (e.g., MYSQL_8_0, POSTGRES_14)."
  type        = string
}

variable "region" {
  description = "The region to deploy the Cloud SQL instance."
  type        = string
}

variable "tier" {
  description = "The machine type to use (e.g., db-custom-2-7680)."
  type        = string
}

variable "availability_type" {
  description = "The availability type (ZONAL or REGIONAL)."
  type        = string
  default     = "REGIONAL"
}

variable "disk_size" {
  description = "The size of data disk in GB."
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "The type of data disk (PD_SSD or PD_HDD)."
  type        = string
  default     = "PD_SSD"
}

variable "ipv4_enabled" {
  description = "Whether the instance should be assigned an IPv4 address."
  type        = bool
  default     = false
}

variable "private_network" {
  description = "The VPC network to which the instance is connected."
  type        = string
  default     = null
}

variable "authorized_networks" {
  description = "List of authorized external networks."
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "root_password" {
  description = "The password for the root user."
  type        = string
  sensitive   = true
}

variable "labels" {
  description = "A map of labels to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "db_user" {
  description = "The name of the default database user."
  type        = string
}

variable "db_password" {
  description = "The password for the default database user."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the default database to create."
  type        = string
}
