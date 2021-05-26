module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"
  # source = "../submodules/tags" # For testing

  user_tags = var.user_tags
  name      = var.domain_name
}

# Create security group
module "security_group" {
  source = "github.com/variant-inc/lazy-terraform//submodules/security_group?ref=v1"
  # source = "../submodules/security_group" # For testing

  user_tags     = var.user_tags
  port          = "6379"
  protocol      = "tcp"
  inbound_cidrs = var.inbound_cidrs
  name          = "${var.domain_name}-ec"
  vpc_id        = var.vpc_id
}

# Get subnets for ES cluster nodes
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"
  # source = "../submodules/subnets" # For testing

  vpc_id = var.vpc_id
}

# ES related resources
resource "aws_elasticache_parameter_group" "cluster" {
  name        = var.domain_name
  family      = var.family
  description = "Used by ${var.domain_name}"
}

resource "aws_elasticache_subnet_group" "cluster" {
  name        = var.domain_name
  subnet_ids  = module.subnets.subnets.ids
  description = "Used by ${var.domain_name}"
  tags        = module.tags.tags
}

resource "aws_elasticache_cluster" "cluster" {
  cluster_id           = var.domain_name
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.cluster.id
  engine_version       = var.engine_version
  maintenance_window   = var.maintenance_window
  security_group_ids   = [module.security_group.security_group.id]
  subnet_group_name    = aws_elasticache_subnet_group.cluster.name
  tags                 = module.tags.tags
}
