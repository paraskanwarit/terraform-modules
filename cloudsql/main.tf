resource "google_sql_database_instance" "primary" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_autoresize   = true
    disk_size         = var.disk_size
    disk_type         = var.disk_type

    backup_configuration {
      enabled            = true
      start_time         = "03:00"
    }

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }

    activation_policy             = "ALWAYS"
    deletion_protection_enabled  = false
    user_labels                  = var.labels
  }

  deletion_protection = false
}

resource "google_sql_user" "default" {
  name     = var.db_user
  instance = google_sql_database_instance.primary.name
  password = var.db_password
}

resource "google_sql_database" "default" {
  name     = var.db_name
  instance = google_sql_database_instance.primary.name
  charset  = "UTF8"
  collation = "en_US.UTF8"
}
