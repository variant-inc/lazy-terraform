# Contributing to this repository

## Getting Started

1. Always use the latest version of terraform.
2. Try not to use unofficial modules. AWS official modules are recommended.

## Folder Structure

Create a folder name with a name as of the module

<https://www.terraform.io/docs/language/modules/develop/structure.html>

```text
<module name>
 ┣ modules
 ┃ ┗ <sub-module>
 ┃ ┃ ┣ main.tf
 ┃ ┃ ┣ variables.tf
 ┃ ┃ ┗ versions.tf
 ┣ policies
 ┃ ┣ iam.yml
 ┃ ┣ rds.yml
 ┃ ┣ route53_skip.yml
 ┃ ┣ secretsmanager.yml
 ┃ ┣ security_group.yml
 ┃ ┗ security_group_skip.yml
 ┣ tests
 ┃ ┣ vars
 ┃ ┃ ┣ test1.json
 ┃ ┃ ┗ test2.json
 ┃ ┣ main.tf
 ┣ main.tf
 ┣ outputs.tf
 ┣ README.md
 ┣ variables.tf
 ┗ versions.tf
```

- main.tf - contains terraform resources, data, modules.
- version.tf - terraform required versions + providers
- outputs.tf - All outputs of the module
- variables.tf - Variables needed by the module
- README.md - should contain Input Parameters and Example
- policies - Policy Sentry Policies required by the module <https://policy-sentry.readthedocs.io/en/latest/>. You can find some examples in rds module. [Link Here](./rds/policies)
- tests - Tests that should be run on the module

## Tests

1. Add terraform files that will use the module to create the resources to `tests` directory.
2. If there are multiple tests with different vars, add a `vars` folder inside the `tests` directory with tfvars files.

## Best Reference

[rds](./rds)

## Octopus Tests

Project: [lazy-terraform](https://octopus.apps.ops-drivevariant.com/app#/Spaces-2/projects/lazy-terraform/deployments)

1. Click Deploy on the Release equivalent to your branch
2. Type the module to be tested in Parameters
3. Select `Try Apply & Destroy` if you want to run terraform run and destroy
