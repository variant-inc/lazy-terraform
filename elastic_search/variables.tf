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

variable "inbound_cidrs" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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

variable "user_tags" {
  description = "Mandatory tags fot the elk resources"
  type = map(string)
}

variable "octopus_tags" {
  description = "Mandatory octopus fot the elk resources"
  type = map(string)
}
