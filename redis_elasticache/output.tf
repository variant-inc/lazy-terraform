output "cache_nodes" {
  value       = aws_elasticache_cluster.cluster.cache_nodes
  description = "List of node objects including id, address, port and availability_zone"
}

output "arn" {
  value       = aws_elasticache_cluster.cluster.arn
  description = "The ARN of the created ElastiCache Cluster"
}

output "engine_version_actual" {
  value       = aws_elasticache_cluster.cluster.engine_version_actual
  description = "The running version of the cache engine"
}
