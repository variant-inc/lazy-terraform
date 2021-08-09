module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  name = "kms/sns"
}

# Get data for tags
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "sns" {
  description             = "KMS Key for SNS Topics"
  deletion_window_in_days = 7
  tags                    = module.tags.tags
  enable_key_rotation     = true

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow access through sns.amazonaws.com",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow_for_AWS_Services",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "s3.amazonaws.com",
          "cloudwatch.amazonaws.com",
          "events.amazonaws.com",
          "dynamodb.amazonaws.com",
          "glacier.amazonaws.com",
          "redshift.amazonaws.com",
          "ses.amazonaws.com",
          "codecommit.amazonaws.com",
          "dms.amazonaws.com",
          "ds.amazonaws.com",
          "importexport.amazonaws.com"
        ]
      },
      "Action": ["kms:Decrypt", "kms:GenerateDataKey*"],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_kms_alias" "sns" {
  name          = "alias/ops/sns"
  target_key_id = aws_kms_key.sns.key_id
}
