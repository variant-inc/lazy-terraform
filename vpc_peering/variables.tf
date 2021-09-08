variable "vpc_src_profile" {
  description = "VPC requestor profile"
}

variable "vpc_src_region" {
  description = "VPC requestor region"
}

variable "vpc_dest_profile" {
  description = "VPC acceptor profile"
}

variable "vpc_dest_region" {
  description = "VPC acceptor region"
}

variable "name_tag_value" {
  description = "Name tag value"
}

variable "user_tags" {
  description = "User tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
