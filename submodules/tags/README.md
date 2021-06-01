# Tags

Module to create tags

<!-- markdownlint-disable MD013 MD033 -->
## Input Variables

| Name            | Type                                                                        | Default Value | Example                                                                               |
| --------------- | --------------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------------- |
| user_tags       | object({ <br />team = string<br /> purpose = string<br /> owner = string<br /> }) |               | {<br />  team= "devops"<br /> purpose= "elk module test"<br /> owner= "Samir"<br /> } |
| octopus_tags    | object({ <br />project = string<br /> space = string<br />  })                    |               | {<br />  project = "actions-test"<br /> space   = "Default"<br /> }                   |
| name            | string                                                                      |               | "Test"                                                                                |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tf file module reference

```bash
  module "tags" {
    source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

    user_tags = {
      team = "devops"
      purpose = "elk module test"
      owner = "Samir"
    }
    octopus_tags = {
      project = "actions-test"
      space   = "Default"
    }

    name            = "Test"
  }
```

## Get Tags

```bash
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing

  user_tags = {
    team= "devops"
    purpose= "elk module test"
    owner= "Samir"
  }
  octopus_tags = {
    project = "actions-test"
    space   = "Default"
  }

  name            = var.domain_name
}

output "tags" {
  value = module.tags.tags
}
```
