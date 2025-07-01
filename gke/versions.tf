terraform { # Start of the Terraform block
  required_providers { # Specify required providers
    google = { # Google provider block
      source  = "hashicorp/google" # Provider source
      version = ">= 4.0.0"         # Minimum version of Google provider
    }
    random = { # Random provider block
      source  = "hashicorp/random" # Provider source
      version = ">= 3.0.0"         # Minimum version of Random provider
    }
  }
  required_version = ">= 1.0.0" # Minimum required Terraform version
} # End of the Terraform block
