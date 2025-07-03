// Production-grade Google CloudSQL instance
// See: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance

resource "google_sql_database_instance" "primary" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  settings {
    tier                        = var.tier
    availability_type           = var.availability_type
    disk_autoresize             = true
    disk_size                   = var.disk_size
    disk_type                   = var.disk_type
    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      start_time                     = "03:00"
    }
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network
      require_ssl     = true
      authorized_networks = var.authorized_networks
    }
    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }
    activation_policy = "ALWAYS"
    deletion_protection_enabled = true
  }

  root_password = var.root_password

  deletion_protection = true

  // Add labels for environment, owner, etc.
  labels = var.labels
}

resource "google_sql_user" "default" {
  name     = var.db_user
  instance = google_sql_database_instance.primary.name
  password = var.db_password
}

resource "google_sql_database" "default" {
  name     = var.db_name
  instance = google_sql_database_instance.primary.name
  charset  = "utf8"
  collation = "utf8_general_ci"
}
