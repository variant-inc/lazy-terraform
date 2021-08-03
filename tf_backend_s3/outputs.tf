output "dynamodb_table" {
  value = module.dynamodb_table.dynamo_db_table.name
}

output "state_bucket" {
  value = module.bucket.bucket_name
}

output "vars_bucket" {
  value = join("", module.bucket_vars.*.bucket_name)
}
