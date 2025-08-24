# Create a Security Group for EC2 instances
resource "aws_security_group" "ecs_to_mongo_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for ECS instances"
  vpc_id      = var.vpc_id

  # Allow all traffic within the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow dynamic port range from ALB
  ingress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
