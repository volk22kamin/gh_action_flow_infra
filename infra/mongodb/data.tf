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
