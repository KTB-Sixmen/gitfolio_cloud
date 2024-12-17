resource "aws_route53_record" "gitfolio" {
  count   = terraform.workspace == "prod" ? 1 : 0
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
  count   = terraform.workspace == "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.gitfolio.zone_id
  name    = format("api.%s", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
  type    = "A"
  
  alias {
    name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name))
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gitfolio_dev" {
  count   = terraform.workspace == "dev" ? 1 : 0
  zone_id = data.aws_route53_zone.gitfolio.zone_id
  name    = format("dev.%s", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
  type    = "A"
  
  alias {
    name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name))
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins" {
  count  = terraform.workspace == "feature-cicd" ? 1 : 0
  zone_id = data.aws_route53_zone.gitfolio.zone_id
  name    = format("jenkins.%s", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
  type    = "A"

  alias {
    name                   = substr(var.alb_dns_name, 0, length(var.alb_dns_name))
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}