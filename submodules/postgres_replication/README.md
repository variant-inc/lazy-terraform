# Postgres Replication

Module to create required tables for replication

> To run the module in a local machine, make sure that postgresql-client is installed

## Input Variables

| Name        | Type   | Default Value | Example                                       |
| ----------- | ------ | ------------- | --------------------------------------------- |
| db_host     | string |               | test.cfubiw5nehry.us-west-2.rds.amazonaws.com |
| db_name     | string |               | name                                          |
| db_user     | string | variant       |                                               |
| db_password | string |               | some_password                                 |
| db_port     | number | 5432          |                                               |

## Example .tf file module reference

```bash
  resource "postgresql_database" "my_db" {
    name = "test"
  }

  module "postgres_replication" {
    source = "github.com/variant-inc/lazy-terraform//submodules/postgres_replication?ref=v1"

    depends_on = [postgresql_database.my_db]

    db_host = "test.cfubiw5nehry.us-west-2.rds.amazonaws.com"
    db_name = "test"
    db_password = "FZugy6QkT2"
    db_name = "variant"
  }
```
