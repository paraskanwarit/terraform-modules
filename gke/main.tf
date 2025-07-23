resource "google_container_cluster" "primary" {
  name     = var.name
  location = var.region
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  enable_autopilot = true

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  master_auth {
    username = "admin"
    password = random_password.gke_password.result
  }

  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }
}

resource "random_password" "gke_password" {
  length  = 16
  special = true
}

# Enable Anthos Service Mesh (ASM) via GKE Hub Feature
resource "google_gke_hub_feature" "asm" {
  name     = "servicemesh"
  project  = var.project_id
  location = "global"
  spec {
    multicluster {
      config_membership = google_gke_hub_membership.gke.id
    }
  }
}

resource "google_gke_hub_membership" "gke" {
  membership_id = var.name
  project       = var.project_id
  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.primary.id
    }
  }
  location = "global"
}
