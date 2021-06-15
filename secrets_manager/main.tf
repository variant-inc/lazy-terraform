module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  name         = "secrets-manager-terraform"
  octopus_tags = var.octopus_tags
}

resource "aws_secretsmanager_secret" "secret" {
  kms_key_id  = var.kms_key_id
  name        = var.name
  description = var.description
  tags        = module.tags.tags
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_value
}