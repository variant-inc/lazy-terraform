# KMS for SNS

Module to create KMS for SNS topics

## Resources

- KMS

## Input Variables

| Name         | Type   | Default Value | Example     |
| ------------ | ------ | ------------- | ----------- |
| user_tags    | object |               | `see below` |
| octopus_tags | object |               | `see below` |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Example .tf file module reference

```bash
  module "kms_sns" {
    source = "github.com/variant-inc/lazy-terraform//kms_sns?ref=v1"

    user_tags = {
      team= "devops"
      purpose= "elk module test"
      owner= "Samir"
    }
  }

  output "kms_sns" {
    value = module.kms_sns.kms
  }
```
