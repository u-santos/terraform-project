output "aws_ecs_cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "The ID of ECS cluster"
}

output "aws_ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
}
