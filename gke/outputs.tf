output "cluster_name" { # Output for the GKE cluster name
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "endpoint" { # Output for the GKE cluster endpoint
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "ca_certificate" { # Output for the cluster CA certificate
  description = "The cluster CA certificate (base64 encoded)"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}
