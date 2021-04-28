variable "vpc_id" {
  type = string
  description = "ID of VPC where efs is created"
}

variable "volume_name" {
  type = string
  description = "Friendly name of the efs volume"
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

variable "profile" {
  type = string
  default = "default"
  description = "AWS Profile Name"
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "AWS Region"
}