terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  policies= [
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
  ]
}

provider "aws" {
  region = var.aws_default_region
  profile = var.aws_profile
}

resource "aws_iam_user" "user" {
  name = var.iam_user_name
  path = var.iam_path

  tags = {
    purpose = var.iam_user_description
  }
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_policy" "policy" {
  name        = var.iam_user_policy_name
  path        = var.iam_path
  description = var.iam_user_policy_description

  policy = replace(file(var.iam_policy_json), "aws_account_number", var.aws_account_number)
}

resource "aws_iam_policy_attachment" "custom_policy_attach" {
  name       = var.iam_user_policy_name
  users      = [aws_iam_user.user.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy_attachment" "aws_policy_attach" {
  count       = length(local.policies)
  name        = var.iam_user_policy_name
  users       = [aws_iam_user.user.name]
  policy_arn  = element(local.policies, count.index)
}