resource "aws_route53_record" "gitfolio" {
  zone_id = data.aws_route53_zone.gitfolio.zone_id
  name    = format("www.%s", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
  type    = "A"
  
  alias {
    name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name))
    #name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name) - 1)
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gitfolio_api" {
  zone_id = data.aws_route53_zone.gitfolio.zone_id
  name    = format("api.%s", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
  type    = "A"
  
  alias {
    name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name))
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}