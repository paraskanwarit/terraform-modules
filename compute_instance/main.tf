/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Define local values for use throughout the module
locals {
  hostname      = var.hostname == "" ? "default" : var.hostname # If hostname variable is empty, use 'default', else use the provided hostname
  num_instances = length(var.static_ips) == 0 ? var.num_instances : length(var.static_ips) # If no static IPs are provided, use num_instances, else use the number of static IPs

  # Workaround for Terraform type errors: append a dummy IP if static_ips is empty
  static_ips = concat(var.static_ips, ["NOT_AN_IP"]) # Ensures the list always has at least one element
  project_id = length(regexall("/projects/([^/]*)", var.instance_template)) > 0 ? flatten(regexall("/projects/([^/]*)", var.instance_template))[0] : null # Extracts the project ID from the instance template string if present

  # If neither network nor subnetwork is defined, use settings from the template (empty list disables network_interface block)
  network_interface = length(format("%s%s", var.network, var.subnetwork)) == 0 ? [] : [1] # If both are empty, return [], else [1] to trigger the dynamic block
}

###############
# Data Sources
###############

data "google_compute_zones" "available" {
  project = local.project_id # The GCP project ID to search for zones
  region  = var.region      # The region to search for available zones
}

#############
# Instances
#############

resource "google_compute_instance_from_template" "compute_instance" {
  provider            = google # Use the Google provider
  count               = local.num_instances # Create as many instances as needed
  name                = var.add_hostname_suffix ? format("%s%s%s", local.hostname, var.hostname_suffix_separator, format("%03d", count.index + 1)) : local.hostname # If add_hostname_suffix is true, append a suffix to the hostname
  project             = local.project_id # The GCP project ID
  zone                = var.zone == null ? data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)] : var.zone # If no zone is specified, spread instances across available zones
  deletion_protection = var.deletion_protection # Enable/disable deletion protection
  resource_policies   = var.resource_policies # Attach resource policies if any
  labels              = var.labels # Set labels for the instance

  params {
    resource_manager_tags = var.resource_manager_tags # Set resource manager tags if provided
  }

  # Dynamically create network_interface block if network/subnetwork is specified
  dynamic "network_interface" {
    for_each = local.network_interface # Only create if not empty

    content {
      network            = var.network # VPC network name
      subnetwork         = var.subnetwork # Subnetwork name
      subnetwork_project = var.subnetwork_project # Project for the subnetwork
      network_ip         = length(var.static_ips) == 0 ? "" : element(local.static_ips, count.index) # Assign static IP if provided
      # Add access_config blocks for each access_config object
      dynamic "access_config" {
        for_each = var.access_config # Loop over access_config list
        content {
          nat_ip       = access_config.value.nat_ip # NAT IP address
          network_tier = access_config.value.network_tier # Network tier (e.g., PREMIUM)
        }
      }

      # Add ipv6_access_config blocks for each ipv6_access_config object
      dynamic "ipv6_access_config" {
        for_each = var.ipv6_access_config # Loop over ipv6_access_config list
        content {
          network_tier = ipv6_access_config.value.network_tier # Network tier for IPv6
        }
      }

      # Add alias_ip_range blocks for each alias_ip_ranges object
      dynamic "alias_ip_range" {
        for_each = var.alias_ip_ranges # Loop over alias_ip_ranges list
        content {
          ip_cidr_range         = alias_ip_range.value.ip_cidr_range # CIDR range for alias IP
          subnetwork_range_name = alias_ip_range.value.subnetwork_range_name # Subnetwork range name
        }
      }
    }
  }

  source_instance_template = var.instance_template # The instance template to use for creating the VM
}

