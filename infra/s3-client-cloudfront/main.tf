# module "cloudfront" {
#   source                = "./modules/cloudfront"
#   name                  = var.cloudfront_name
#   s3_bucket_domain_name = module.client_s3.bucket_domain_name
#   bucket_name           = module.client_s3.bucket_id
#   bucket_arn            = module.client_s3.bucket_arn
#   api_alb_dns_name      = var.api_alb_dns_name
#   acm_arn               = var.acm_arn
#   tags                  = var.default_tags

#   providers = {
#     aws = aws.region_eu_central
#   }
# }

module "client_s3" {
  source                   = "./modules/client-s3"
  bucket_name              = "${var.client_s3_bucket_name}-${var.region}"
  tags                     = var.default_tags
  server_url               = var.client_s3_server_url

  providers = {
    aws = aws.region_eu_central
  }
}