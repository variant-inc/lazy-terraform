variable "profile" {
  description = "AWS profile"
  default     = "default"
}

variable "name" {
  description = "Name of the SNS topic"
}

variable "user_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
