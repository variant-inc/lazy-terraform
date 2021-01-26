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

resource "aws_cloudwatch_log_group" "flow" {
  name = "flow"
  tags = {
    Name  = "${var.vpc_name}-vpc"
    purpose = "Flog logs for ${var.vpc_name} VPC"
  }
}

resource "aws_iam_role" "flow" {
  name = "flow"
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
  name = "flow"
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