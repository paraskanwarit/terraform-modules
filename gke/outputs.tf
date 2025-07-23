output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "asm_membership_id" {
  value = google_gke_hub_membership.gke.id
}
