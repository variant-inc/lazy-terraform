terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

resource "aws_iam_policy" "iam-policy" {
  name = var.policy_name
  description = var.policy_description

  policy = file("${path.module}/policies/test_policy.tf.json")

  tags = {
    Name        = var.policy_name
    Environment = var.profile
  }
}
