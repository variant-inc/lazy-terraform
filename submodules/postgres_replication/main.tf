resource "null_resource" "replication" {
  triggers = {
    "host" = var.db_host
    "name" = var.db_name
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "psql -f replication.sql"

    environment = {
      PGPASSWORD = nonsensitive(var.db_password)
      PGUSER     = var.db_user
      PGHOST     = var.db_host
      PGPORT     = var.db_port
      PGDATABASE = var.db_name
    }
  }
}
