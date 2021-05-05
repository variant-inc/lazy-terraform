variable "profile" {
  description = "AWS Account Number"
  default     = "default"
}

variable "region" {
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Elastic Search Domain Name"
}

variable "vpc_id" {
  description = "VPC to create the cluster in"
}

variable "ebs_volume_size" {
  description = "Elastic Search Security Options"
  type = number
  default = 100
}

variable "cluster_config" {
  description = "Elastic Search Security Options"
  type = map(string)
}

variable "master_user_options" {
  description = "Elastic Search Security Options"
  type = map(string)
}