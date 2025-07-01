resource "google_container_cluster" "primary" { # Creates the main GKE cluster
  name     = var.name # Cluster name from variable
  location = var.region # Cluster region from variable
  project  = var.project_id # GCP project ID from variable

  network    = var.network # VPC network name
  subnetwork = var.subnetwork # Subnetwork name

  remove_default_node_pool = true # Remove default node pool to define custom ones
  initial_node_count       = 1    # Required, but not used (set to 1)

  ip_allocation_policy { # Configure IP allocation for pods and services
    cluster_secondary_range_name  = var.ip_range_pods # Secondary range for pods
    services_secondary_range_name = var.ip_range_services # Secondary range for services
  }

  master_auth { # Master authentication block
    username = "admin" # Admin username
    password = random_password.gke_password.result # Randomly generated password
  }

  # Enable the Kubernetes Dashboard
  addons_config {
    kubernetes_dashboard {
      disabled = false # Enable the dashboard
    }
  }
}

resource "random_password" "gke_password" { # Generates a random password for the cluster admin
  length  = 16 # Password length
  special = true # Include special characters
}

resource "google_container_node_pool" "primary_nodes" { # Creates node pools for the cluster
  for_each = { for np in var.node_pools : np.name => np } # Loop over node_pools variable

  name       = each.value.name # Node pool name
  cluster    = google_container_cluster.primary.name # Attach to the main cluster
  location   = var.region # Region
  project    = var.project_id # Project ID

  node_config { # Node configuration
    machine_type = each.value.machine_type # Machine type
    disk_size_gb = each.value.disk_size_gb # Disk size
    preemptible  = each.value.preemptible # Preemptible nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform" # Full cloud platform access
    ]
  }

  autoscaling { # Enable autoscaling for the node pool
    min_node_count = each.value.min_count # Minimum nodes
    max_node_count = each.value.max_count # Maximum nodes
  }
}
