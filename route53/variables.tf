variable "sub_domain" {
  description = "The name of the sub_domain"
  type        = string
}

variable "records" {
  description = "List of Records"
  type        = list(string)
}

variable "type" {
  description = "Type of Route"
  default     = "CNAME"
}
