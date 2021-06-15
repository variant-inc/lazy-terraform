# Create IAM role for firehose stream with inline policy
resource "aws_iam_role" "firehose_role" {
  name               = "firehose_role-${var.kinesis_firehose_delivery_stream}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  inline_policy {
    name   = "firehose_role_policy-${var.kinesis_firehose_delivery_stream}"
    policy = data.aws_iam_policy_document.inline_policy_document.json
  }
}

# Create IAM role for lambda with inline policy
resource "aws_iam_role" "s3_extended_role" {
  name               = "s3_extended_role-${var.kinesis_firehose_delivery_stream}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  inline_policy {
    name   = "s3_extended_role_policy-${var.kinesis_firehose_delivery_stream}"
    policy = data.aws_iam_policy_document.inline_policy_document.json
  }
}

# Create inline policy document that will be tied to firehose and lambda roles
data "aws_iam_policy_document" "inline_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::s3-${var.kinesis_firehose_delivery_stream}",
      "arn:aws:s3:::s3-${var.kinesis_firehose_delivery_stream}/*",
      "arn:aws:s3-object-lambda:*:*:accesspoint/*",
      "arn:aws:s3:*:*:accesspoint/*",
      "arn:aws:s3:*:*:job/*",
      "arn:aws:s3:*:*:storage-lens/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "firehose:*",
      "kinesis:*",
      "sns:*",
      "sqs:*",
      "glue:GetTableVersion",
      "lambda:InvokeFunction",
      "glue:GetTableVersions",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "lambda:GetFunctionConfiguration",
      "kinesis:DescribeStream",
      "logs:PutLogEvents",
      "glue:GetTable",
      "kms:DescribeCustomKeyStores",
      "kms:ListKeys",
      "kms:DeleteCustomKeyStore",
      "kms:GenerateRandom",
      "kms:UpdateCustomKeyStore",
      "kms:ListAliases",
      "kms:DisconnectCustomKeyStore",
      "kms:CreateKey",
      "kms:ConnectCustomKeyStore",
      "kms:CreateCustomKeyStore"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:*:*:alias/*",
      "arn:aws:kms:*:*:key/*"
    ]
  }
}