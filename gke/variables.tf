variable "project_id" { # GCP project ID
  description = "The project ID to host the cluster in"
  type        = string
}

variable "name" { # Cluster name
  description = "The name of the cluster"
  type        = string
}

variable "region" { # GCP region
  description = "The region to host the cluster in"
  type        = string
}

variable "network" { # VPC network name
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" { # Subnetwork name
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "ip_range_pods" { # Secondary IP range for pods
  description = "The secondary IP range to use for pods"
  type        = string
}

variable "ip_range_services" { # Secondary IP range for services
  description = "The secondary IP range to use for services"
  type        = string
}

variable "node_pools" { # List of node pool objects
  description = "List of maps describing node pools"
  type        = list(object({
    name         = string # Node pool name
    machine_type = string # Machine type
    min_count    = number # Minimum node count
    max_count    = number # Maximum node count
    disk_size_gb = number # Disk size in GB
    preemptible  = bool   # Preemptible nodes
  }))
}
