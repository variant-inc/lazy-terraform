module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  dynamodb_table_name         = var.dynamodb_table_name
  kms_key_enable_key_rotation = false
  replica_bucket_prefix       = var.replica_bucket_prefix
  state_bucket_prefix         = var.state_bucket_prefix
  terraform_iam_policy_create = false

  tags = {
    owner = "devops"
    purpose = "lazy terraform state storage"
    env = var.environment
  }

  providers = {
    aws                         = aws
    aws.replica                 = aws.replica
  }
}

resource "aws_kms_alias" "kms" {
  name          = "alias/${var.state_bucket_prefix}"
  target_key_id = module.remote_state.kms_key.arn
}