variable "region" {
  type = string
  default = "us-east-1"
  description = "Default region for AWS provider"
}

variable "profile" {
  type = string
  description = "Credentials profile for AWS provider"
}

variable "s3_bucket_name" {
  type    = string
  default = "name-not-provided"
  description = "Name given to s3 bucket"
}

variable "purpose" {
  type = string
  description = "Purpose of the bucket,used for tags"
}

variable "owner" {
  type = string
  description = "Owner of the bucket,used for tags"
}

variable "team" {
  type = string
  description = "team own this bucket,used for tags"
}

variable "lazy_api_host" {
  type = string
  default = "lazyapi-test.apps.ops-drivevariant.com"
}

variable "lazy_api_key" {
  type = string
  # sensitive   = true
}