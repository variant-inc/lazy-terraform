# IAM Policy Module

Module to create IAM Role in a lazy fasion

## Input Variables

<!-- markdownlint-disable MD013 MD033 -->
| Name                          | Type            | Description                                                                  | Default Value | Example                           |
| ----------------------------- | --------------- | ---------------------------------------------------------------------------- | --------------| ----------------                  |
| name                          | string          | Name of the role to be created                                               |               |                                   |
| description                   | string          | Description of the role to be created                                        |               |                                   |
| trust_octopus_worker          | bool            | Add trust relationship to iaac-octopus-worker in both devops and current environment | False         |                                   |
| managed_policies              | list(string)    | List of arns of managed policies to attach to new role                       |               |                                   |
| inline_policies               | list(object({Name = string, policy_json = object({Version = string, Statement = list(object({Sid = string, Effect = string, Action = string, Resource = string}))})}))| List of inline policy definitions |               |                                   |
| user_tags                     | map(string)     | Mandatory User Tags                                                          |               |                                   |
| octopus_tags                  | map(string)     | Octopus Tags                                                                 |               |                                   |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tfvars.json

```bash
{
  "name": "test-role-lee",
  "description": "Test role for iam role tf module",
  "managed_policies": ["arn:aws:iam::aws:policy/ReadOnlyAccess"],
  "trust_octopus_worker": true,
  "inline_policies": [
    {
      "name": "inline_policy_1",
      "policy_json": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "*"
          }
        ]
      }
    },
    {
      "name": "inline_policy_2",
      "policy_json": {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::dummy-world/*"
          }
        ]
      }
    }
  ],
  "user_tags": {
    "team": "devops",
    "purpose": "testing iam role tf module",
    "owner": "Lee"
  },
  "octopus_tags": {
    "space": "test_space",
    "project": "test_project"
  }
}
```

## Test as module

```bash
module "iam_role" {
  source = "github.com/variant-inc/lazy-terraform//iam_role?ref=feature/CLOUD-37-add-iam-role"

  name                 = var.name
  description          = var.policy_description
  managed_polices      = var.managed_polices
  trust_octopus_worker = var.trust_octopus_worker
  inline_policies      = var.inline_policies

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
}
```

## Output Variables
- aws_iam_role.role.*.arn
  - list(string)
