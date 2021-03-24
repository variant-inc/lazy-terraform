# Terraform S3 State Backend

Module to create s3, dynamodb & KMS for terraform s3 backend

## Input Variables

- aws_profile
  - string
- region
  - string
- environment
  - string
- dynamodb_table_name
  - string
- replica_bucket_prefix
  - string
- state_bucket_prefix
  - string

## Example .tfvars

```bash
aws_profile = "profile"
region = "us-east-1"
environment = "stage"

dynamodb_table_name = "engineering_tf_state"
replica_bucket_prefix = "engineering-tf-state-replica"
state_bucket_prefix = "engineering-tf-state"
```
