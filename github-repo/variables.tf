variable "name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = ""
}

variable "private" {
  description = "Whether the repo is private"
  type        = bool
  default     = true
}
