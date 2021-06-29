module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.name
}

resource "aws_iam_role" "role" {
  name                  = var.name
  description           = var.description != "" ? var.description : "role for ${var.name}"
  force_detach_policies = true
  assume_role_policy    = var.trust_octopus_worker ? data.aws_iam_policy_document.assume_role.json : null

  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.value["name"]
      policy = jsonencode(inline_policy.value["policy_json"])
    }
  }

  managed_policy_arns = var.managed_policies
  tags                = module.tags.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::108141096600:role/iaac-octopus-worker", data.aws_iam_role.octopus.arn]
    }
  }
}

data "aws_iam_role" "octopus" {
  name = "iaac-octopus-worker"
}
