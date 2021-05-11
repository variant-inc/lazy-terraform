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

variable "user_tags" {
  description = "Mandatory tags fot the elk resources"
  type = object({
    octopus-project_name = string
    octopus-space_name = string
    Team = string
    Purpose = string
    Owner = string
  })
}

variable "ebs_volume_size" {
  description = "Elastic Search Security Options"
  type = number
  default = 100
}

variable "cluster_config" {
  description = "Elastic Search Security Options. See "
  type = map(string)
}

variable "master_user_options" {
  description = "Elastic Search Security Options"
  type = map(string)
}