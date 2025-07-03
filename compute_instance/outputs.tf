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

# Output the self-links (unique resource URLs) for all created compute instances
output "instances_self_links" {
  description = "List of self-links for compute instances" # Explains what this output is
  value       = google_compute_instance_from_template.compute_instance[*].self_link # Gets the self_link for each instance
}

# Output all details for the created compute instances (marked sensitive for security)
output "instances_details" {
  description = "List of all details for compute instances" # Explains what this output is
  sensitive   = true # Marks the output as sensitive so it won't be shown in logs
  value       = google_compute_instance_from_template.compute_instance[*] # Gets all attributes for each instance
}

# Output the list of available zones in the selected region
output "available_zones" {
  description = "List of available zones in region" # Explains what this output is
  value       = data.google_compute_zones.available.names # Gets the names of all available zones
}
