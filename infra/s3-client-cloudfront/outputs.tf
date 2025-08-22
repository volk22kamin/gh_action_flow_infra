output "client_s3_bucket_id" {
  description = "The ID of the client S3 bucket"
  value       = module.client_s3.bucket_id
}

output "client_s3_bucket_arn" {
  description = "The ARN of the client S3 bucket"
  value       = module.client_s3.bucket_arn
}

output "client_s3_bucket_domain_name" {
  description = "The domain name of the client S3 bucket"
  value       = module.client_s3.bucket_domain_name
}

output "client_s3_website_endpoint" {
  description = "The website endpoint of the client S3 bucket"
  value       = module.client_s3.website_endpoint
}

output "client_s3_index_object_etag" {
  description = "ETag of the uploaded index.html object"
  value       = module.client_s3.index_object_etag
}

# output "cloudfront_distribution_id" {
#   description = "The ID of the CloudFront distribution"
#   value       = module.cloudfront.distribution_id
# }

# output "cloudfront_distribution_arn" {
#   description = "The ARN of the CloudFront distribution"
#   value       = module.cloudfront.distribution_arn
# }

# output "cloudfront_domain_name" {
#   description = "The domain name of the CloudFront distribution"
#   value       = module.cloudfront.domain_name
# }

# output "cloudfront_oac_id" {
#   description = "The ID of the CloudFront Origin Access Control"
#   value       = module.cloudfront.oac_id
# }