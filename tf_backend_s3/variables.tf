variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "name" {
  description = "Name of the dyanmodb table and prefix of s3 bucket"
}

variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "lazy_api_host" {
  type    = string
  default = "https://lazy.apps.ops-drivevariant.com"
}

variable "lazy_api_key" {
  type      = string
  sensitive = true
}
