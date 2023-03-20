output "aws_iam_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "aws_ecs_agent_name_role" {
  value       = aws_iam_instance_profile.ecs_agent_role.name
  description = "The name of ECS agent from iam instance profile"
}
