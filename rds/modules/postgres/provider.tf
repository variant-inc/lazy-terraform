provider "postgresql" {
  host            = var.host
  username        = var.username
  password        = var.password
  connect_timeout = 30
  superuser       = false
  database        = var.name
}
