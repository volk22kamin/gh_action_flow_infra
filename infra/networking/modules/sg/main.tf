resource "aws_security_group" "alb" {
    name        = "alb-sg"
    description = "alb-sg" 
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow HTTP from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS from anywhere"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.default_tags, { Name = "default" })
}

resource "aws_security_group" "ecs" {
    name        = "ecs-sg"
    description = "ecs-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow app traffic from ALB"
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = merge(var.default_tags, { Name = "ecs-sg" })
}

resource "aws_security_group" "mongodb" {
    name        = "mongodb-sg"
    description = "mongodb-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow MongoDB from ECS"
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        security_groups = [aws_security_group.ecs.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    tags = merge(var.default_tags, { Name = "db-sg" })
}