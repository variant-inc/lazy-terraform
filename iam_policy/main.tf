module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags = var.user_tags
  octopus_tags = var.octopus_tags
  name = var.policy_name
}

resource "aws_iam_policy" "iam-policy" {
  name        = var.policy_name
  description = var.policy_description

  policy = jsonencode(var.policy_json)

  tags = module.tags.tags
}
