# VPC

Module to get default vpc

## Resources

- VPC

## Input Variables

| Name | Type   | Default Value | Example     |
| ---- | ------ | ------------- | ----------- |
| name | string |               | default-vpc |

## Example .tf file module reference

```bash
  module "vpc" {
    source = "github.com/variant-inc/lazy-terraform//submodules/vpc?ref=v1"
  }

  output "vpc" {
    value = module.vpc.vpc.id
  }
```
