# Terraform VPC Setup Module

This module create a VPC peering connection in the same account

## Input Variables

- requestor_vpc_id
  - string
- acceptor_vpc_id
  - string
- environment
  - string

## Example .tfvars

```text
requestor_vpc_id = "vpc-123"
acceptor_vpc_id = "vpc-234"
environment = "devops"
```
