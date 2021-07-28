variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "table_name" {
  description = "Name of the dyanmodb table and prefix of s3 bucket"
}

variable "bucket_prefix" {
  description = "Prefix of s3 bucket"
}

variable "user_tags" {
  description = "Mandatory User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Mandatory Octopus Tags"
  type        = map(string)
}

variable "create_vars_bucket" {
  description = "Create Vars Bucket"
  type        = bool
  default     = false
}
