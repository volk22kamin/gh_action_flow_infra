module "acm" {
  source           = "./modules/acm"
  primary_domain   = "${var.domain_name}"
  san_domains      = ["api.${var.domain_name}"]
  route53_zone_id  = var.route53_zone_id
  cloudfront_domain_name = var.cloudfront_domain_name
  domain_name      = var.domain_name
}
