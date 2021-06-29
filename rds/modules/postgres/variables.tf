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
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

