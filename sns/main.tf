module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags

  name = var.name
}

resource "aws_sns_topic" "sns" {
  name              = var.name
  kms_master_key_id = "alias/ops/sns"
}
