resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.name}-oac"
  description                       = "OAC for CloudFront to access private S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.name}"
  default_root_object = "index.html"
  aliases = ["volk.baby"]

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = "${var.name}-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  dynamic "origin" {
    for_each = var.api_alb_dns_name != "" ? [1] : []

    content {
      domain_name = var.api_alb_dns_name
      origin_id   = "${var.name}-alb-origin"

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.name}-s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
    origin_request_policy_id   = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # ✅ Managed-CORS-S3Origin

  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "${var.name}-alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods   = ["GET", "HEAD"]

    cache_policy_id = "2e54312d-136d-493c-8eb9-b001f22f67d2"  # Managed-CachingDisabled

    origin_request_policy_id = "59781a5b-3903-41f3-afcb-af62929ccde1" # AllViewer


  }


  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IL"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_arn  
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  tags = var.tags
}

resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${var.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })
}
