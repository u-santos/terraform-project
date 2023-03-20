output "aws_iam_role_arn" {
  value = aws_iam_role.ecs_tasks_execution_role.arn
}

output "aws_ecs_agent_name" {
  value       = aws_iam_instance_profile.ecs_agent.name
  description = "The name of ECS agent from iam instance profile"
}
