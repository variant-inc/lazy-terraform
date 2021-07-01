variable "policies" {
  description = "IAM Policies from Policy Sentry"
  type = list(object({
    file_path = string
    name      = string
  }))
}

variable "attachReadOnlyPolicy" {
  description = "Attach Read Only Policy"
  type        = bool
  default     = false
}

variable "attachAdminAccessPolicy" {
  description = "Attach Admin Access Policy"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the IAM role"
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
