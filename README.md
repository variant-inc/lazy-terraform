# Lazy Terraform Modules

Terraform scripts for lazy folks

## Usage

All modules can be imported by tags. For example, to create a SNS topic module, import the module to your tf file as below

```bash
module "sns" {
  source = "github.com/variant-inc/lazy-terraform//sns?ref=v1"

  name = "some-topic"

  user_tags = {
    team = "devops"
    purpose = "elk module test"
    owner = "Samir"
  }
  octopus_tags = var.octopus_tags
}
```

## Notes

1. `octopus_tags` variable is auto filled if run through octopus. Use the variable snippet provided below.

    ```bash
    variable "octopus_tags" {
      description = "Octopus Tags"
      type = map(string)
    }
    ```

2. If creating a module that isn't supported by lazy-terraform, make sure that you add the appropriate tags by following the [tags module](submodules/tags/README.md)
