data "aws_route53_zone" "gitfolio" {
  name = format("%s.", substr(var.route53_domain, 2, length(var.route53_domain) - 2))
}