# Tags

Module to create tags

<!-- markdownlint-disable MD013 MD033 -->
## Input Variables

| Name      | Type                                                                                                                                                                                                                                                          | Default Value | Example                                                                                                                                                                                                                            |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| user_tags | object({ <br />    octopus-project_name = string<br />    octopus-space_name   = string<br />    team                 = string<br />    purpose              = string<br />    owner                = string<br />    name                 = string<br />  }) |               | {<br />            octopus-project_name= "actions-test"<br />            octopus-space_name = "Default"<br />            team= "devops"<br />            purpose= "elk module test"<br />            owner= "Samir"<br />        } |
| name      | string                                                                                                                                                                                                                                                        |               | "Test"                                                                                                                                                                                                                             |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tf file module reference

```bash
  module "tags" {
    source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

    user_tags= {
      octopus-project_name= "actions-test"
      octopus-space_name = "Default"
      team= "devops"
      purpose= "elk module test"
      owner= "Samir"
    }
    name = "Test"
  }
```

## Get Tags

```bash
module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing

  user_tags = {
    octopus-project_name= "actions-test"
    octopus-space_name = "Default"
    team= "devops"
    purpose= "elk module test"
    owner= "Samir"
  }
  name      = var.domain_name
}

output "tags" {
  value = module.tags.tags
}
```
