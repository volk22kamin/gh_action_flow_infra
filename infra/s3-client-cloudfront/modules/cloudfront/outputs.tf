output "distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "oac_id" {
  description = "The ID of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.this.id
}
