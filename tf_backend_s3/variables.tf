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

variable "lazy_api_host" {
  description = "Lazy API URL. Auto Filled by Octopus"
  type        = string
  default     = "https://lazy.apps.ops-drivevariant.com"
}

variable "lazy_api_key" {
  description = "Lazy API Key. Auto Filled by Octopus"
  type        = string
  sensitive   = true
}

variable "aws_role_to_assume" {
  description = "Role used by boto3 to create/destroy s3 bucket"
  type        = string
}
