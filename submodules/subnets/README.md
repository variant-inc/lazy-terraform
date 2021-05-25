# Security Group

Module to create security group

## Resources

- Security Group
- Security Group Rules
- Tags

## Input Variables

| Name          | Type          | Default Value | Example |
| ------------- | ------------- | ------------- | ------- |
| vpc_id | string |  | vpc-123456789        |
| type          | string        | "private"         |         |

## Example .tf file module reference

```bash
  module "subnets" {
    source = "github.com/variant-inc/lazy-terraform//submodules/subnets"

    vpc_id = "vpc-123456789"
  }
```
