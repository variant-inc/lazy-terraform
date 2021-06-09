# Secrets Manager

Module to create secrets in secrets manager

## Resources

- Tags
- Secrets Manager

## Input Variables

 | Name                         | Type          | Default             | Example           |
 | ---------------------------- | ------------- | ------------------- | ----------------- |
 | name                         | string        |                     |                   |
 | secret_value                 | string        |                     |                   |
 | kms_key_id                   | string        |    null             |                   |
 | user_tags                    | object        |                     |                   |
 | octopus_tags                 | object        |                     |                   |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Example .tf file module reference

**prerequisites:**

set below environment variables as per the needs, before running the module.
export AWS_DEFAULT_REGION="us-east-1"
export AWS_DEFAULT_REGION="devops"

```bash

variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}

module "secret" {
  source = "git::https://github.com/variant-inc/lazy-terraform//secrets_manager?ref=v1"
  #For branch
  #source = "git::https://github.com/variant-inc/lazy-terraform//secrets_manager?ref=feature/CLOUD-409-secrets-manager"

  name="dummy-secret5"
  secret_value="GGRRThhg"
  kms_key_id="add if you have kms key"
  user_tags = {
    team= "devops"
    purpose= "secrets manager test"
    owner= "naveen"
  }
  octopus_tags = var.octopus_tags # If run from octopus, this will be auto set
}
```
