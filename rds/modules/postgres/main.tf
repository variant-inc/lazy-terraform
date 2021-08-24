locals {
  roles_ro = [
    "ba",
    "tableau",
    "pm",
    "data"
  ]
}

resource "random_password" "roles_ro_password" {
  count = var.enabled ? length(local.roles_ro) : 0

  length  = 16
  special = false
}

resource "postgresql_role" "roles_ro" {
  count = var.enabled ? length(local.roles_ro) : 0

  name             = element(local.roles_ro, count.index)
  login            = true
  connection_limit = 5
  password         = random_password.roles_ro_password[count.index].result
}

resource "postgresql_grant" "readonly_tables" {
  depends_on = [
    postgresql_role.roles_ro
  ]

  count = var.enabled ? length(local.roles_ro) : 0

  database    = var.name
  role        = element(local.roles_ro, count.index)
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}

resource "aws_secretsmanager_secret" "ro_roles" {
  count = var.enabled ? 1 : 0

  name                    = "${var.identifier}-rds-roles"
  tags                    = var.tags
  description             = "Read Only Roles with password for ${var.identifier}-rds"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ro_roles" {
  count = var.enabled ? 1 : 0

  secret_id     = aws_secretsmanager_secret.ro_roles[0].id
  secret_string = jsonencode(zipmap(local.roles_ro, random_password.roles_ro_password.*.result))
}

resource "postgresql_role" "create" {
  count = var.username != "postgres" ? 1 : 0

  name        = "postgres"
  login       = true
  create_role = true
  password    = var.create_password
}
