variable "domain_name" {
  description = "Elastic Search Domain Name"
}

variable "family" {
  description = "The family of the ElastiCache parameter group"
  default     = "redis6.x"
}

variable "node_type" {
  description = "The instance class used"
  default     = "cache.m6g.large"
}

variable "engine_version" {
  description = "Version number of the cache engine to be used"
  default     = "6.x"
}

variable "maintenance_window" {
  description = <<EOT
  "Specifies the weekly time range for when maintenance on the cache cluster is performed.
  The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period.
  Example: sun:05:00-sun:09:00"
EOT
  default     = "sun:05:00-sun:09:00"
}

variable "vpc_id" {
  description = "VPC to create the cluster in. If it is empty, then cluster will be created in `default-vpc`"
  default     = ""
}

variable "inbound_cidrs" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  default     = ["0.0.0.0/0"]
}

variable "user_tags" {
  description = "Mandatory tags fot the elk resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}
