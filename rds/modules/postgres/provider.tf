provider "postgresql" {
  host            = var.host
  username        = var.username
  password        = var.password
  connect_timeout = 30
  superuser       = false
  database        = var.name
}

terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.12.0"
    }
  }
}
