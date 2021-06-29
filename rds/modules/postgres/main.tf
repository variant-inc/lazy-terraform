local {
  roles_ro = [
    "ba",
    "tableau",
    "pm",
    "data"
  ]
}

resource "random_password" "roles_ro_password" {
  count = length(local.roles_ro)

  length  = 16
  special = false
}

resource "postgresql_role" "roles_ro" {
  count = length(local.roles_ro)

  name             = element(local.roles_ro, count.index)
  login            = true
  connection_limit = 5
  password         = random_password.roles_ro_password[count.index].result
}

resource "postgresql_grant" "readonly_tables" {
  count = length(local.roles_ro)

  database    = var.name
  role        = element(local.roles_ro, count.index)
  schema      = "public"
  object_type = "database"
  privileges  = ["SELECT"]
}

resource "aws_secretsmanager_secret" "ro_roles" {
  name                    = "${var.identifier}-rds-roles"
  tags                    = var.tags
  description             = "Read Only Roles with password for ${var.identifier}-rds"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "ro_roles" {
  secret_id     = aws_secretsmanager_secret.ro_roles.id
  secret_string = jsonencode(zipmap(roles_ro, random_password.roles_ro_password.*.result))
}
