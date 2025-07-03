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

# The VPC network to deploy the instance into. Only one of network or subnetwork should be specified.
variable "network" {
  description = "Network to deploy to. Only one of network or subnetwork should be specified."
  type        = string
  default     = ""
}

# The subnetwork to deploy the instance into. Only one of network or subnetwork should be specified.
variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  type        = string
  default     = ""
}

# The project that the subnetwork belongs to.
variable "subnetwork_project" {
  description = "The project that subnetwork belongs to"
  type        = string
  default     = ""
}

# The hostname to assign to the VM instances.
variable "hostname" {
  description = "Hostname of instances"
  type        = string
  default     = ""
}

# Whether to add a numeric suffix to the hostname (useful for multiple instances).
variable "add_hostname_suffix" {
  description = "Adds a suffix to the hostname"
  type        = bool
  default     = true
}

# List of static IPs to assign to the VM instances. If empty, dynamic IPs are used.
variable "static_ips" {
  type        = list(string)
  description = "List of static IPs for VM instances"
  default     = []
}

# List of access configuration objects for external (NAT) access.
variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string # The external NAT IP address
    network_tier = string # The network tier (e.g., PREMIUM, STANDARD)
  }))
  default = []
}

# List of IPv6 access configuration objects for external IPv6 access.
variable "ipv6_access_config" {
  description = "IPv6 access configurations. Currently a max of 1 IPv6 access configuration is supported. If not specified, the instance will have no external IPv6 Internet access."
  type = list(object({
    network_tier = string # The network tier for IPv6
  }))
  default = []
}

# Number of VM instances to create. Ignored if static_ips is provided.
variable "num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = "1"
}

# The self_link of the instance template to use for creating the VM instances.
variable "instance_template" {
  description = "Instance template self_link used to create compute instances"
  type        = string
}

# The region in which to create the VM instances.
variable "region" {
  type        = string
  description = "Region where the instances should be created."
  default     = null
}

# The zone in which to create the VM instances. If not specified, instances are spread across available zones in the region.
variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
  default     = null
}

# The separator character to use when composing hostnames with suffixes.
variable "hostname_suffix_separator" {
  type        = string
  description = "Separator character to compose hostname when add_hostname_suffix is set to true."
  default     = "-"
}

# Whether to enable deletion protection on the VM instance.
variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection on this instance. Note: you must disable deletion protection before removing the resource, or the instance cannot be deleted and the Terraform run will not complete successfully."
  default     = false
}

# List of alias IP ranges to assign to the network interface.
variable "alias_ip_ranges" {
  description = "(Optional) An array of alias IP ranges for this network interface. Can only be specified for network interfaces on subnet-mode networks."
  type = list(object({
    ip_cidr_range         = string # The CIDR range for the alias IP
    subnetwork_range_name = string # The name of the subnetwork range
  }))
  default = []
}

# List of resource policies to attach to the instance. Modifying this list will cause the instance to be recreated.
variable "resource_policies" {
  description = "(Optional) A list of short names or self_links of resource policies to attach to the instance. Modifying this list will cause the instance to recreate. Currently a max of 1 resource policy is supported."
  type        = list(string)
  default     = []
}

# Map of labels to assign to the VM instance. These override labels from the template.
variable "labels" {
  type        = map(string)
  description = "(Optional) Labels to override those from the template, provided as a map"
  default     = null
}

# Map of resource manager tags to assign to the VM instance. Tags are key-value pairs for policy control.
variable "resource_manager_tags" {
  description = "(Optional) A tag is a key-value pair that can be attached to a Google Cloud resource. You can use tags to conditionally allow or deny policies based on whether a resource has a specific tag. This value is not returned by the API. In Terraform, this value cannot be updated and changing it will recreate the resource."
  type        = map(string)
  default     = null
}
