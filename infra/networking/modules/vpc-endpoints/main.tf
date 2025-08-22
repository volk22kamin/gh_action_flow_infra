resource "aws_security_group" "default_vpce" {
  name        = "vpc-endpoint-sg"
  description = "Default SG for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, { Name = "vpc-endpoint-sg" })
}

resource "aws_vpc_endpoint" "this" {
  for_each = { for vpce in var.vpc_endpoints : "${vpce.service_name}-${vpce.type}" => vpce }

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.type
  auto_accept       = true
  tags              = merge(var.default_tags, each.value.tags)

  # For Interface endpoints
  security_group_ids = each.value.type == "Interface" ? [aws_security_group.default_vpce.id] : null
  subnet_ids         = each.value.type == "Interface" ? var.subnet_ids : null
  private_dns_enabled = each.value.type == "Interface" ? each.value.private_dns_enabled : null

  # For Gateway endpoints
  route_table_ids = each.value.type == "Gateway" ? var.route_table_ids : null
}
