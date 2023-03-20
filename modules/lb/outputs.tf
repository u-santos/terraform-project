output "aws_lb_main_arn" {
  value = aws_lb.main.arn
}

output "aws_lb_main_id" {
  value = aws_lb.main.id
}

output "aws_lb_main_dns" {
  value = aws_lb.main.dns_name
}

output "lb_arn_suffix" {
  value       = aws_lb.main.arn_suffix
  description = "The Load Balancer ARN suffix for use with CloudWatch Metrics."
}
