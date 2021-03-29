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
