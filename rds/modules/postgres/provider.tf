provider "postgresql" {
  host             = var.host
  username         = var.username
  password         = var.password
  connect_timeout  = 30
  expected_version = "current"
  superuser        = false
}