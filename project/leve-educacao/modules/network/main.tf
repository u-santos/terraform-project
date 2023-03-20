resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.default_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = var.default_tags
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "sa-east-1a"

  tags = merge(var.default_tags, {
    Name = "Terraform private 1a"
  })
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1b"

  tags = merge(var.default_tags, {
    Name = "Terraform private 1b"
  })
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "sa-east-1a"

  tags = merge(var.default_tags, {
    Name = "Terraform public 1a"
  })
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1b"

  tags = merge(var.default_tags, {
    Name = "Terraform public 1b"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.default_tags, {
    Name = "Terraform public_rt"
  })
}

resource "aws_route_table_association" "public_rta_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rta_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow incoming database connections"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = var.rds_port
    to_port         = var.rds_port
    protocol        = "tcp"
    security_groups = var.aws_service_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "Terraform database sg"
  })
}

resource "aws_security_group" "ecs_sg" {
  name   = "lms-ecs-cluster-sg"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.list_port_service_container
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "Terraform ecs cluster sg"
  })
}

resource "aws_db_subnet_group" "default" {
  name       = "db-${var.service_name}-${var.environment}"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = merge(var.default_tags, {
    Name = "Terraform database subnet group"
  })
}

# resource "aws_eip" "nat" {
#   vpc  = true
#   tags = var.default_tags
# }

# resource "aws_nat_gateway" "gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_subnet_a.id
# }

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.default_tags, {
    Name = "Terraform lms private_rt"
  })
}
