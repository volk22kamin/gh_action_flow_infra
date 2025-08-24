api_alb_dns_name = "secure-app-server-1742084758.eu-central-1.elb.amazonaws.com"
acm_arn = "arn:aws:acm:us-east-1:667308168455:certificate/e08c0cfa-0643-4b5a-b575-041fa9ec5b2a"
region = "eu-central-1"
client_s3_bucket_name = "secure-app-client"
client_s3_index_document = "index.html"
client_s3_server_url = "/api"
cloudfront_name = "secure-app-cloudfront"
default_tags = {
  Environment = "production"
  Project     = "secure-app"
  Owner       = "volk"
  ManagedBy   = "Terraform"
}
