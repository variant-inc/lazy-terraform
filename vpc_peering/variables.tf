variable "profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "environment" {
  description = "The Deployment environment"
}

variable "requestor_vpc_id" {
  description = "VPC ID of Requester"
}

variable "acceptor_vpc_id" {
  description = "VPC ID of Acceptor"
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
