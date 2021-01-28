output "iaac_policy_arn" {
  value = aws_iam_policy.policy.arn
}

output "iaac_access_key_id" {
  value = aws_iam_access_key.user.id
}

output "iaac_access_key_secret" {
  value = aws_iam_access_key.user.secret
}
