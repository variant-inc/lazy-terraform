output "iam_policy_arn" {
  value = [aws_iam_policy.iam-policy.*.arn]
}
