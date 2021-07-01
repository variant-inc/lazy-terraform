variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where s3 bucket need to be created"
}

variable "profile" {
  type        = string
  description = "Profile where s3 bucket need to created"
}

variable "bucket_name" {
  type        = string
  default     = "name-not-provided"
  description = "Name given to s3 bucket"
}

variable "lazy_api_host" {
  type    = string
  default = "https://lazy.apps.ops-drivevariant.com"
}

variable "lazy_api_key" {
  type      = string
  sensitive = true
}

variable "role_arn" {
  type = string
}

variable "replication" {
  type    = bool
  default = false
}

variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
