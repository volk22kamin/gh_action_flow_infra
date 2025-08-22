output "public_nacl_id" {
  description = "The ID of the public network ACL"
  value       = aws_network_acl.public.id
}