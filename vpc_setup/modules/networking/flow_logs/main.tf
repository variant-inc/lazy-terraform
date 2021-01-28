resource "aws_flow_log" "flow" {
  iam_role_arn    = aws_iam_role.flow.arn
  log_destination = aws_cloudwatch_log_group.flow.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id

  tags = {
    Name  = "${var.vpc_name}-vpc"
    purpose = "Flog logs for ${var.vpc_name} VPC"
  }
}

resource "aws_kms_key" "kms" {
  description  = "KMS key CloudWatch Group ${var.vpc_name}-vpc"

  tags = {
    purpose = "${var.vpc_name}-vpc"
    owner   = "devops"
  }
}

resource "aws_kms_alias" "kms" {
  name          = "alias/${var.vpc_name}-vpc"
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_cloudwatch_log_group" "flow" {
  name        = "${var.vpc_name}-vpc"
  kms_key_id  = aws_kms_key.kms.key_id
  tags = {
    Name  = "${var.vpc_name}-vpc"
    purpose = "Flog logs for ${var.vpc_name} VPC"
  }
}

resource "aws_iam_role" "flow" {
  name = "${var.vpc_name}-vpc"
  tags = {
    Name  = "${var.vpc_name}-vpc"
    purpose = "Flog logs for ${var.vpc_name} VPC"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow" {
  name = "${var.vpc_name}-vpc"
  role = aws_iam_role.flow.id
  tags = {
    Name  = "${var.vpc_name}-vpc"
    purpose = "Flog logs for ${var.vpc_name} VPC"
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}