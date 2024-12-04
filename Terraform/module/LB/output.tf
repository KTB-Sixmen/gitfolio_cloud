output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value = aws_lb.alb.zone_id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value = aws_lb.alb.dns_name
}