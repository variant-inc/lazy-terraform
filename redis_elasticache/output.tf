output "cache_nodes" {
  value       = aws_elasticache_cluster.cluster.cache_nodes
  description = "List of node objects including id, address, port and availability_zone"
}

output "result" {
  value       = aws_elasticache_cluster.cluster
  description = "The output of aws_elasticache_cluster.cluster"
}

output "engine_version_actual" {
  value       = aws_elasticache_cluster.cluster.engine_version_actual
  description = "The running version of the cache engine"
}
