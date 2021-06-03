variable "db_host" {
  description = "Host of the Postgres DB Cluster"
}

variable "db_port" {
  description = "Port of the Postgres DB Cluster"
  default = 5432
}

variable "db_name" {
  description = "Name of the Database"
}

variable "db_user" {
  description = "Master User of DB Cluster"
  default     = "variant"
}

variable "db_password" {
  description = "Master Password of DB Cluster"
}
