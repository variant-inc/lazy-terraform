variable "host" {
  description = "Hostname of the cluster"
  type        = string
}

variable "username" {
  description = "Master Username"
  type        = string
}

variable "password" {
  description = "Master Password"
  type        = string
  sensitive   = true
}

variable "name" {
  description = "Database Name"
  type        = string
  default     = "postgres"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "enabled" {
  description = "Enable Postgres User Creation"
  type        = bool
}

variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

