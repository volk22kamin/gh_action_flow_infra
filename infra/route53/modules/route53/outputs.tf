output "zone_id" {
  description = "The ID of the Route53 hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "The nameservers for the Route53 hosted zone"
  value       = aws_route53_zone.this.name_servers
}
