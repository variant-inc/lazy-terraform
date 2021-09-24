variable "src_name_tag" {
  description = "Source Name tag value"
  type        = string
}

variable "dest_name_tag" {
  description = "Destination Name tag value"
  type        = string
}

variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
