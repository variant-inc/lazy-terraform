# IAM Policy Module

Module to create IAM Policy in a lazy fashion

## Input Variables

<!-- markdownlint-disable MD013 MD033 -->
| Name               | Type                                                                                                                      | Description                             | Default Value | Example |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | ------------- | ------- |
| policy_description | string                                                                                                                    | Description of the policy to be created |               |         |
| policy_name        | string                                                                                                                    | Name of the policy to be created        |               |         |
| policy_json        | object({Version = string, Statement = list(object({Sid = string, Effect = string, Action = string, Resource = string}))}) | JSON Policy Definition                  |               |         |
| user_tags          | map(string)                                                                                                               | Mandatory User Tags                     |               |         |
| octopus_tags       | map(string)                                                                                                               | Octopus Tags                            |               |         |
<!-- markdownlint-enable MD013 MD033 -->

## Example .tfvars

```bash
policy_description = "This is a test policy"
policy_name = "Test_Policy_Lee_TF"
policy_json = {
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
user_tags = {
    team = "devops"
    purpose = "iam"
    owner = "lee"
}
octopus_tags = {
    project = "iaac_octopus"
    space = "DevOps"
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
