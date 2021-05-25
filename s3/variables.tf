variable "region" {
  type = string
  default = "us-east-1"
  description = "Region where s3 bucket need to be created"
}

variable "profile" {
  type = string
  description = "Profile where s3 bucket need to created"
}

variable "bucket_name" {
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
  default = "https://lazy.apps.ops-drivevariant.com"
}

variable "lazy_api_key" {
  type = string
  sensitive = true
}

variable "octopus_project_space" {
  type = string
  default = ""
}

variable "octopus_project_name" {
  type = string
  default = ""
}