data "aws_iam_role" "octopus" {
  name = "iaac-octopus-worker"
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  user_tags = {
    team    = "cloudops"
    purpose = "policy for ${var.name}"
    owner   = "cloudops"
  }
  octopus_tags = var.octopus_tags

  name = var.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_iam_role.octopus.arn
      ]
    }
  }
}

resource "aws_iam_role" "role" {
  name                  = var.name
  description           = "role for ${var.name}"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  max_session_duration  = 43200

  dynamic "inline_policy" {
    for_each = var.policies
    content {
      name   = inline_policy.value["name"]
      policy = file(inline_policy.value["file_path"])
    }
  }

  tags = module.tags.tags
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count = var.attachReadOnlyPolicy ? 1 : 0

  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  count = var.attachAdminAccessPolicy ? 1 : 0

  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
