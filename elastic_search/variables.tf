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

variable "es_version" {
  description = "Elastic Search Version"
  default     = "7.10"
}

variable "vpc_id" {
  description = "VPC to create the cluster in"
}

variable "inbound_cidr" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  default     = "0.0.0.0/0"
}

variable "user_tags" {
  description = "Mandatory tags fot the elk resources"
  type = object({
    octopus-project_name = string
    octopus-space_name   = string
    team                 = string
    purpose              = string
    owner                = string
  })
}

variable "ebs_volume_size" {
  description = "Elastic Search EBS volume size"
  type        = number
  default     = 100
}

variable "cluster_config" {
  description = "Elastic Search Cluster Config "
  type        = map(string)
}

variable "master_user_options" {
  description = "Elastic Search User Options"
  type        = map(string)
}
