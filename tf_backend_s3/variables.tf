variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "name" {
  description = "Name of the dyanmodb table and prefix of s3 bucket"
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

variable "role_arn" {
  description = "Role used by boto3 to create/destroy s3 bucket"
  type        = string
}
