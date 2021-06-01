variable "vpc_id" {
  description = "VPC to create the cluster in"
}

variable "type" {
  description = "Port to be opened"
  default     = "private"

  validation {
    condition     = contains(["private", "public"], var.type)
    error_message = "Allowed values for `type` are \"private\" or \"public\"."
  }
}
