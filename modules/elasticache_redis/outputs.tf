output "replication_group_id" {
  value       = aws_elasticache_replication_group.default.id
  description = "The ID of the ElastiCache Replication Group."
}

output "primary_endpoint_address" {
  value       = aws_elasticache_replication_group.default.primary_endpoint_address
  description = "The address of the endpoint for the primary node in the replication group."
}

output "configuration_endpoint_address" {
  value       = aws_elasticache_replication_group.default.configuration_endpoint_address
  description = "The address of the replication group configuration endpoint when cluster mode is enabled."
}

output "member_clusters" {
  value       = aws_elasticache_replication_group.default.member_clusters
  description = "Node members of the Elasticache Cluster."
}

output "cluster" {
  value       = aws_elasticache_replication_group.default
  description = "Elasticache cluster resource."
}
