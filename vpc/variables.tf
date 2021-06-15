variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "cidr" {
  description = "The CIDR block of the vpc"
}

variable "name" {
  description = "Name of the VPC"
  default     = "default"
}

variable "user_tags" {
  description = "Mandatory tags for all resources"
  type = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
