# GKE Terraform Module
# This module provisions a Google Kubernetes Engine (GKE) cluster on Google Cloud Platform.

## Usage Example

```hcl
module "gke" {
  source           = "../gke" # Path to this module
  project_id       = var.project_id # GCP project ID
  name             = var.name # Cluster name
  region           = var.region # GCP region
  network          = var.network # VPC network
  subnetwork       = var.subnetwork # Subnetwork
  ip_range_pods    = var.ip_range_pods # Secondary range for pods
  ip_range_services = var.ip_range_services # Secondary range for services
  node_pools       = var.node_pools # Node pool configuration
}
```

## Inputs
- `project_id`: GCP project ID
- `name`: Name of the GKE cluster
- `region`: GCP region
- `network`: VPC network name
- `subnetwork`: Subnetwork name
- `ip_range_pods`: Secondary range for pods
- `ip_range_services`: Secondary range for services
- `node_pools`: List of node pool objects

## Outputs
- `cluster_name`: Name of the GKE cluster
- `endpoint`: Endpoint of the GKE cluster
- `ca_certificate`: Cluster CA certificate
