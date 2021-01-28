resource "aws_iam_policy" "policy" {
  count       = length(var.iam_policy_json)
  name        = element(var.iam_policy_json, count.index)
  path        = var.iam_path
  description = "Policy for EKS to run ${replace(element(var.iam_policy_json, count.index), "-policy", "")}"

  policy      = replace(file("policies/${element(var.iam_policy_json, count.index)}.json"), "aws_account_number", var.aws_account_number)
}
