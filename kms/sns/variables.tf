variable "profile" {
  description = "AWS profile"
  default     = "default"
}

variable "user_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)

  default = {
    team    = "cloudops"
    purpose = "KMS for SNS"
    owner   = "Vibin"
  }
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)

  default = {
    project = "n/a"
    space   = "n/a"
  }
}
