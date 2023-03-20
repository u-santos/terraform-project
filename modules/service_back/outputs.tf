output "aws_service_security_group_id" {
  value       = aws_security_group.main.id
  description = "The ID from service security group."
}
