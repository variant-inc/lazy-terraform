variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where s3 bucket will be created"
}

variable "bucket_name" {
  type        = string
  description = "Name of the s3 bucket. Either one of bucket_name or bucket_prefix is required. bucket_name gets highest preference"
  default = ""
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix of the s3 bucket. Either one of bucket_name or bucket_prefix is required"
  default = ""
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
