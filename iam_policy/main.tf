resource "aws_iam_policy" "iam-policy" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode(var.policy_json)

  tags = {
    Name        = var.policy_name
    Environment = var.profile
  }
}
