variable "inbound_cidrs" {
  description = "CIDR block to expect requests to originate from ie the source/destination in es' security group"
  default     = ["0.0.0.0/0"]
}

variable "port" {
  description = "Port to be opened"
  default     = "443"
}

variable "protocol" {
  description = "Protocol of the port that has to be opened"
  default     = "tcp"
}

variable "tags" {
  description = "User Tags for security group"
  type = object()
}

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "vpc_id" {
  description = "VPC to create the cluster in"
}
