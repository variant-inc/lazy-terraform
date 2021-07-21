variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where s3 bucket will be created"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix of the s3 bucket"
}

variable "lazy_api_host" {
  type        = string
  default     = "https://lazy.apps.ops-drivevariant.com"
  description = "Lazy API - auto set by octopus"
}

variable "lazy_api_key" {
  type        = string
  sensitive   = true
  description = "Lazy API Key - auto set by octopus"
}

variable "role_arn" {
  type        = string
  description = "Role to assume while creating bucket. Auto set by octopus"
}

variable "env" {
  description = "prod env supports replication"
  type        = string
  validation {
    condition     = contains(["prod", "non-prod"], var.env)
    error_message = "Supported values are [\"prod\", \"non-prod\"]."
  }
}

variable "user_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
