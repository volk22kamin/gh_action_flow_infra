output "vpc_endpoint_ids" {
  description = "IDs of the created VPC endpoints"
  value       = [for vpce in aws_vpc_endpoint.this : vpce.id]
}

output "vpc_endpoint_arns" {
  description = "ARNs of the created VPC endpoints"
  value       = [for vpce in aws_vpc_endpoint.this : vpce.arn]
}

output "vpc_endpoint_network_interface_ids" {
  description = "Network interface IDs for interface endpoints"
  value       = {
    for k, vpce in aws_vpc_endpoint.this :
    k => vpce.network_interface_ids
    if vpce.vpc_endpoint_type == "Interface"
  }
}

output "security_group_id" {
  description = "ID of the security group created for VPC endpoints"
  value       = aws_security_group.default_vpce.id
}