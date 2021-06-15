# Security Group

Module to create security group

## Resources

- Security Group
- Security Group Rules
- Tags

## Input Variables

| Name   | Type   | Default Value | Example       |
| ------ | ------ | ------------- | ------------- |
| vpc_id | string |               | vpc-123456789 |
| type   | string | "private"     |               |


## Example .tf file module reference

```bash
  module "subnets" {
    source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"

    vpc_id = "vpc-123456789"
  }
```

## Get Subnets

```bash
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"
  # source = "../submodules/subnets" # For testing

  vpc_id = var.vpc_id
  type   = "private"
}

output "subnets" {
  value = module.subnets.subnets.ids
}
```
