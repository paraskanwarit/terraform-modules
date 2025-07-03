# Production-Grade Google CloudSQL Terraform Module

This module creates a production-ready Google CloudSQL instance, user, and database using the official [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance).

## Features
- Highly available (REGIONAL) CloudSQL instance
- Automated backups and binary logging
- Private IP support
- Deletion protection enabled
- Custom user and database creation
- Secure password variables (for admin/break-glass only)
- Labels for environment and ownership

## Usage Example
```hcl
module "cloudsql" {
  source           = "./cloudsql"
  instance_name    = "prod-sql-instance"
  database_version = "POSTGRES_14"
  region           = "australia-southeast1"
  tier             = "db-custom-2-7680"
  root_password    = var.sql_root_password
  db_user          = "appuser"
  db_password      = var.sql_app_password
  db_name          = "appdb"
  private_network  = var.vpc_network_self_link
  labels = {
    environment = "production"
    owner       = "team"
  }
}
```

## Workload Identity & Cloud SQL Auth Proxy

**Best Practice:**
- Applications should use [Workload Identity Federation](https://cloud.google.com/sql/docs/postgres/connect-workload-identity) and the [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/postgres/connect-run) to connect to CloudSQL securely, without using static passwords.
- The passwords defined in this module (`root_password`, `db_password`) are required for initial CloudSQL setup and should be used only for admin or break-glass access. Do not distribute these to applications.
- Store these credentials securely (e.g., Secret Manager) and restrict their use.
- Each application container should run the Cloud SQL Auth Proxy as a sidecar or init container, authenticating via a GCP service account with the `roles/cloudsql.client` IAM role.

**Example Auth Proxy Deployment:**
```yaml
containers:
- name: cloud-sql-proxy
  image: gcr.io/cloudsql-docker/gce-proxy:1.37.2
  command: ["/cloud_sql_proxy",
            "-instances=<INSTANCE_CONNECTION_NAME>=tcp:5432",
            "-enable_iam_login"]
  securityContext:
    runAsNonRoot: true
    allowPrivilegeEscalation: false
```

**IAM Setup:**
- Grant your app's GCP service account the `roles/cloudsql.client` role on the CloudSQL instance.
- No need to provide DB credentials to the app; IAM and the proxy handle authentication.

## Variables
See `variables.tf` for all configurable options.

## Outputs
See `outputs.tf` for available outputs.

## Reference
- [google_sql_database_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)
- [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/postgres/connect-run)
- [Workload Identity Federation](https://cloud.google.com/sql/docs/postgres/connect-workload-identity)
