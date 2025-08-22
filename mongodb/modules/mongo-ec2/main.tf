resource "aws_security_group" "mongo" {
  name        = "mongo-sg"
  description = "Allow access to MongoDB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ingress rule for ECS SG, only created if ecs_service_sg_id is set
resource "aws_security_group_rule" "mongo_from_ecs" {
  for_each                 = toset(var.ecs_service_sg_id != null ? var.ecs_service_sg_id : [])

  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mongo.id
  source_security_group_id = each.value
}


resource "aws_instance" "mongo" {
  ami                         = var.mongo_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.mongo.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
#!/bin/bash
set -xe

# Enable MongoDB on boot
systemctl enable mongod

# Modify mongod.conf to allow access from all IPs
MONGO_CONF="/etc/mongod.conf"
if grep -q "^  bindIp: 127.0.0.1" "$MONGO_CONF"; then
  sed -i 's/^  bindIp: 127.0.0.1/  bindIp: 0.0.0.0/' "$MONGO_CONF"
elif grep -q "^bindIp: 127.0.0.1" "$MONGO_CONF"; then
  sed -i 's/^bindIp: 127.0.0.1/bindIp: 0.0.0.0/' "$MONGO_CONF"
fi

# Start mongod in the background to allow user creation
systemctl restart mongod

# Wait for mongod to be ready
until mongosh --eval "print(\"waited for connection\")" &>/dev/null; do
  sleep 2
done

mongosh --eval 'db.getSiblingDB("admin").createUser({user:"admin", pwd:"volk_password", roles:[{role:"root", db:"admin"}]})'

EOF


  tags = {
    Name = "MongoDB"
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "mongo-ssm-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "mongo-ssm-profile"
  role = aws_iam_role.ssm_role.name
}
