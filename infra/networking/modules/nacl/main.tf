resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  # Static Inbound Rules
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  # Remove later to restrict SSH access
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0" # Or restrict to your IP for security
    action     = "allow"
  }

  # Dynamic Ingress Rules for Ephemeral Ports (private subnets)
  dynamic "ingress" {
    for_each = toset(var.private_subnet_cidrs)
    content {
      rule_no = 130 + index(var.private_subnet_cidrs, ingress.key) * 10
      protocol   = "tcp"
      from_port  = 1024
      to_port    = 65535
      cidr_block = ingress.value
      action     = "allow"
    }
  }

  ingress {
    rule_no    = 200
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    action     = "deny"
  }

  # Outbound Rules (static)
  egress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = 120
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = 200
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    action     = "deny"
  }

  tags = merge(var.default_tags, { Name = "public-nacl" })
}
