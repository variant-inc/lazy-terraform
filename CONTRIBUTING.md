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
 ┃ ┣ test.ps1
 ┃ ┗ tests.ps1
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
- policies - Policy Sentry Policies required by the module
- tests - Tests that should be run on the module

## Tests

Tests should contain a test.ps1 which will say how to execute the tests. There should be a terraform main.tf which will contain the module that should be tested

## Best Reference

[rds](./rds)

## Octopus Tests

Project: [lazy-terraform](https://octopus.apps.ops-drivevariant.com/app#/Spaces-2/projects/lazy-terraform/deployments)

1. Click Deploy on the Release equivalent to your branch
2. Type the module to be tested in Parameters
3. Select `Try Apply & Destroy` if you want to run terraform run and destroy
