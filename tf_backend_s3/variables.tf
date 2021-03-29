variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "environment" {
  description = "The Deployment environment"
}

variable "dynamodb_table_name" {
}

variable "replica_bucket_prefix" {
}

variable "state_bucket_prefix" {
}
