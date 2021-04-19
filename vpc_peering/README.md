# Terraform VPC Setup Module

This module create a VPC with private and public subnets

## Input Variables

- vpc_cidr
  - string
- vpc_name
  - string

## Example .tfvars

```text
vpc_cidr = "10.1.10.0/20"
vpc_name = "default"
```
