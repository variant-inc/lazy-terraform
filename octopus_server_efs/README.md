# Octopus Server EFS Module

Module to update Octopus EFS volumes. This module is only for reference

To run this here are the steps

1. Change terraform backend to `local`
2. `terraform init`
3. `terraform plan -target aws_efs_file_system.octopus`
4. `terraform apply -target aws_efs_file_system.octopus`
5. `terraform plan`
6. `terraform apply`
7. Change terraform backend to `s3`
8. `terraform init` and allow push to s3

## Input Variables

- vpc_id
  - string

## Example .tfvars

```bash
vpc_id = "vpc-000000000000"
```
