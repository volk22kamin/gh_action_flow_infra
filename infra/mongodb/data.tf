# data "aws_vpc" "secure_app_vpc" {
#   id = var.vpc_id
# }

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["secure-app-vpc-private-subnet-1"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



data "aws_security_groups" "ecs_service" {
  filter {
    name   = "group-name"
    values = ["basic-todo-app-cluster-sg"]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  ecs_service_sg_id = length(data.aws_security_groups.ecs_service.ids) > 0 ? data.aws_security_groups.ecs_service.ids[0] : null
}
