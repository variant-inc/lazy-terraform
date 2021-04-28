variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
}

variable "replica_bucket_prefix" {
}

variable "state_bucket_prefix" {
}

variable "tag_purpose" {
  type = string
  description = "Purpose Tag"
}

variable "tag_team" {
  type = string
  description = "Team Tag"
}

variable "tag_owner" {
  type = string
  description = "Owner Tag"
}
