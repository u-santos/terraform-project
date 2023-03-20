resource "aws_security_group" "main" {
  name        = "${var.product}-${var.service_name}-${var.environment}"
  vpc_id      = var.aws_vpc_main_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.product}-${var.service_name}-${var.environment}"
  })
}

resource "aws_security_group_rule" "allow_rds_access" {
  type                     = "ingress"
  to_port                  = 0
  from_port                = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.main.id
  security_group_id        = var.rds_sg_id
  description              = "Allow incoming database connections."
}
