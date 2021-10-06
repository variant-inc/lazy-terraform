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

Following variables are set as env Variables by octopus

1. AWS_ACCESS_KEY_ID
2. AWS_SECRET_ACCESS_KEY
3. AWS_SESSION_TOKEN
4. TF_VAR_lazy_api_host
5. TF_VAR_lazy_api_key
6. TF_VAR_aws_role_to_assume
7. TF_VAR_domain (eg: ops-drivevariant.com)
8. TF_VAR_octopus_tags

## Best Reference

[rds](./rds)

## Octopus Tests

Project: [lazy-terraform](https://octopus.apps.ops-drivevariant.com/app#/Spaces-2/projects/lazy-terraform/deployments)

1. Click Deploy on the Release equivalent to your branch. You can choose any one of the environments.
2. Type the module to be tested in Parameters
3. Select `Try Apply & Destroy` if you want to run terraform run and destroy

## Post PR Merge to Master

1. Create a new release in github. Version is of syntax - `v<major>.<minor>.<patch>`. Eg: `v1.2.3`
   1. Increase the patch version if it is bugfix/hotfix.
   2. Increase the minor version if it is a new feature.
   3. Increase the major version if it is a breaking change. Only CloudOps team members will do this
2. Update the v1 tag by the following commands

    ```bash
    git tag -d v1
    git push --delete origin v1
    git tag v1
    git push origin v1
    ```
