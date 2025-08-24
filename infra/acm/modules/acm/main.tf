provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_acm_certificate" "this" {
  provider                  = aws.virginia
  domain_name               = var.primary_domain
  subject_alternative_names = var.san_domains
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  provider                  = aws.virginia
  certificate_arn           = aws_acm_certificate.this.arn
  validation_record_fqdns   = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "root_cf" {
  zone_id = var.route53_zone_id
  name    = var.domain_name        
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "app_cf" {
  zone_id = var.route53_zone_id  
  name    = "app.volk.baby"
  type    = "CNAME"
  ttl     = 300
  records = [var.cloudfront_domain_name]
}
