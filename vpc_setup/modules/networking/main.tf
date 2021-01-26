/*====
The VPC
======*/

resource "aws_vpc" "vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr

  tags = {
    Name        = "${var.vpc_name}-vpc"
    env         = var.environment
  }
}

/*====
Subnets
======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    env         = var.environment
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = {
    Name        = "${var.vpc_name}-nat"
    env         = var.environment
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2 * (count.index + 1))
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-${element(var.availability_zones, count.index)}-public-subnet"
    env         = var.environment
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2 * (count.index + 1) + 1)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.vpc_name}-${element(var.availability_zones, count.index)}-private-subnet"
    env         = var.environment
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-private-route-table"
    env         = var.environment
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-public-route-table"
    env         = var.environment
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name        = "${var.vpc_name}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Name  = "${var.vpc_name}-sg"
    env   = var.environment
  }
}

resource "aws_flow_log" "flow" {
  iam_role_arn    = aws_iam_role.flow.arn
  log_destination = aws_cloudwatch_log_group.flow.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.id

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
    Name    = "${var.vpc_name}-vpc"
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
    Name    = "${var.vpc_name}-vpc"
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