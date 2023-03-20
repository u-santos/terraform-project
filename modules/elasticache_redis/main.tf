resource "aws_elasticache_replication_group" "default" {
  engine               = "redis"
  
  parameter_group_name = var.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  security_group_ids   = [aws_security_group.default.id]

  replication_group_id          = var.resource
  replication_group_description = var.description
  node_type                     = var.node_type
  engine_version                = var.engine_version
  port                          = var.port
  
  maintenance_window          = var.maintenance_window
  snapshot_window             = var.snapshot_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  automatic_failover_enabled  = var.automatic_failover_enabled
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  transit_encryption_enabled  = var.transit_encryption_enabled
  auth_token                  = var.auth_token

  apply_immediately = var.apply_immediately
  tags = merge(var.tags, { Name = var.resource })

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.number_replicas
      num_node_groups         = var.number_shards
    }
  }

  depends_on = [aws_elasticache_subnet_group.default, aws_security_group.default]
}

resource "aws_elasticache_subnet_group" "default" {
  name        = var.resource
  subnet_ids  = var.subnet_ids
  description = var.description

  tags = merge(var.tags, { Name = "${var.resource}-elasticache" })
}

resource "aws_security_group" "default" {
  name   = "${var.resource}-elasticache-redis"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = var.aws_service_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.resource}-elasticache" })
}
