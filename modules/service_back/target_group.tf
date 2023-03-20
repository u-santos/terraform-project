resource "aws_alb_target_group" "main" {
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval  = var.tg_interval
    path      = var.tg_path
    timeout   = var.tg_timeout
    matcher   = var.tg_matcher
    healthy_threshold   = var.tg_healthy_threshold
    unhealthy_threshold = var.tg_unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "main" {
  load_balancer_arn = var.aws_lb_arn
  port              = var.port

  default_action {
    type             = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Access Denied"
            status_code  = "403"
        }
    target_group_arn = aws_alb_target_group.main.arn
  }
}

resource "aws_lb_listener_rule" "validate-header" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 1
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.main.id
  }
  condition {
    http_header {
      http_header_name = "X-Validate-CLF-request"
      values           = ["${var.service_name}-${var.environment}-ZYICDSvu6eT92CtW8do3vOC1RBR-${var.rds_sg_id}"]
    }
  }
}
