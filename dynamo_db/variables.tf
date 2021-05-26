variable "region" {
  type = string
  default = "us-east-1"
  description = "Region where table need to be created"
}

variable "profile" {
  type = string
  description = "Profile where table need to be created"
}

variable "purpose" {
  type = string
  description = "Purpose for creation of the table"
}

variable "owner" {
  type = string
  description = "Owner of the table"
}

variable "team" {
  type = string
  description = "team own this table"
}

variable "octopus_project" {
  type = string
  description = "octopus project"
  default     = ""
}

variable "octopus_space" {
  type = string
  description = "octopus space"
  default     = ""
}

variable "billing_mode" {
  type        = string
  description = "(Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  type = string
  description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
}

variable "hash_key_type" {
  type = string
  description = "hash key type"
}

variable "range_key" {
  type = string
  description = "The attribute to use as the range (sort) key. Must also be defined as an attribute"
  default = null
}

variable "table_name" {
  type = string
  description = "Name of the DynamoDB table"
}

variable "attributes" {
  description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type = list(object({ name = string, type = string }))
    default = null
}

variable "global_secondary_indexes" {
  description = "To add global secondary indexes, maximum of 5 global secondary indexes can be defined for the table"
  type = any          
  default = null
}

variable "local_secondary_indexes" {
  description = "To add local secondary indexes, maximum of 5 global secondary indexes can be defined for the table"
  type = any          
  default = null
}

variable "read_capacity" {
  type        = number
  description = "(Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required."
  default     = 2
}

variable "write_capacity" {
  type        = number
  description = "(Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
  default     = 2
}
