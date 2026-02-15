data "aws_acm_certificate" "gitfolio_issued" {
  domain   = var.route53_domain
  statuses = ["ISSUED"]
}

data "aws_lb" "alb" {
  name = "gitfolio-alb"
}
