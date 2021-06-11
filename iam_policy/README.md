# IAM Policy Module

Module to create IAM Policy in a lazy fasion

## Input Variables

<!-- markdownlint-disable MD013 MD033 -->
| Name                          | Type            | Description                                                                  | Default Value | Example                           |
| ----------------------------- | --------------- | ---------------------------------------------------------------------------- | --------------| ----------------                  |
| profile                       | string          | Environment where table need to be created                                   | default       | prod, devops, dev                 |
| region                        | string          | AWS Default Region                                                           | us-east-1     | us-east-1, us-west-2              |
| policy_description            | string          | Description of the policy to be created                                      |               |                                   |
| policy_name                   | string          | Name of the policy to be created                                             |               |                                   |
| policy_json                   | object({Version = string, Statement = list(object({Sid = string, Effect = string, Action = string, Resource = string}))})| JSON Policy Definition |               |                                   |
| user_tags                     | map(string)     | Mandatory User Tags                                                          |               |                                   |
| octopus_tags                  | map(string)     | Octopus Tags                                                                 |               |                                   |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tfvars

```bash
profile = "devops"
region  = "us-west-2"
policy_description  = "This is a test policy"
policy_name         = "Test_Policy_Lee_TF"
policy_json         = {
                        "Version"   : "2012-10-17",
                        "Statement" : [
                            {
                                "Sid"       : "VisualEditor0",
                                "Effect"    : "Allow",
                                "Action"    : "sts:AssumeRole",
                                "Resource"  : "*"
                            }
                        ]
                    }
```

## Test as module

```bash
module "octopus-policy" {
  source = "github.com/variant-inc/lazy-terraform//iam_policy?ref=v1.1.3"

  policy_name        = var.policy_name
  policy_description = var.policy_description
  policy_json        = var.policy_json
  user_tags          = var.user_tags
  octopus_tags       = var.octopus_tags
}
```

You may have to provide credentials/s3 information when you init the root module

## Output Variables
- aws_iam_policy.iam-policy.*.arn
  - list(str)