variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "cidr" {
  description = "The CIDR block of the vpc"
}

variable "name" {
  description = "Name of the VPC"
  default     = "default-vpc"
}

variable "user_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
