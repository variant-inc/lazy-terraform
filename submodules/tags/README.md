# Tags

Module to create tags

<!-- markdownlint-disable MD013 MD033 -->
## Input Variables

| Name            | Type                                                                        | Default Value | Example                                                                               |
| --------------- | --------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------------- |
| user_tags       | object({ <br />team = string<br /> purpose = string<br /> owner = string<br /> }) |               | {<br />  team= "devops"<br /> purpose= "elk module test"<br /> owner= "Samir"<br /> } |
| octopus_tags    | object({ <br />project = string<br /> space = string<br /> environment = string<br /> project_group = string<br /> release_channel = string<br /> })                    |               | {<br />  project = "actions-test"<br /> space   = "Default"<br /> environment = "development"<br /> project_group = "Default Project Group"<br /> release_channel = "feature"<br />}                   |
| name            | string                                                                      |               | "Test"                                                                                |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tf file module reference

```bash
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  octopus_tags = {
    project         = "actions-test"
    space           = "Default"
    environment     = "development"
    project_group   = "Default Project Group"
    release_channel = "feature"
  }

  name = "Test"
}
```

## Get Tags

Make sure that you add the following to variables since it will be auto filled by octopus

```bash
variable "octopus_tags" {
  type = map(string)
}
```

```bash
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing

  user_tags = {
    team    = "devops"
    purpose = "elk module test"
    owner   = "Samir"
  }
  octopus_tags = var.octopus_tags

  name = var.domain_name
}

output "tags" {
  value = module.tags.tags
}
```

## Tagging AWS Resources

This will tag all AWS provider `resource`s that support tags.

```bash
provider "aws" {
  default_tags {
    tags = module.tags.tags
  }
}
```
