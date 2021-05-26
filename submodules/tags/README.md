# Tags

Module to create tags

## Input Variables

| Name      | Type                                                                                                                                                                                                                                                          | Default Value | Example                                                                                                                                                                                                                            |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| user_tags | object({ <br />    octopus-project_name = string<br />    octopus-space_name   = string<br />    team                 = string<br />    purpose              = string<br />    owner                = string<br />    name                 = string<br />  }) |               | {<br />            octopus-project_name= "actions-test"<br />            octopus-space_name = "Default"<br />            team= "devops"<br />            purpose= "elk module test"<br />            owner= "Samir"<br />        } |
| name      | string                                                                                                                                                                                                                                                        |               | "Test"                                                                                                                                                                                                                             |

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
