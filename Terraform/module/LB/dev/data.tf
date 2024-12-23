data "aws_acm_certificate" "gitfolio_issued" {
    domain = var.route53_domain
    statuses = ["ISSUED"]
}