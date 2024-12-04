# resource "aws_lb_listener_rule" "k8s" {
#   listener_arn = aws_lb_listener.https.arn
#   priority     = 49999

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.k8s.arn
#   }

#   condition {
#     host_header {
#       values = ["api.gitfolio.site"]
#     }
#   }

#   condition {
#     path_pattern {
#       values = ["/api/k8s"]
#     }
#   }

#   tags = {
#     Name = "Gitfolio k8s path based routing"
#   }
# }

# resource "aws_lb_target_group" "k8s" {
#   name                  = "gitfolio-k8s-tg"
#   port                  = var.target_port["k8s"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
#   protocol              = var.target_protocol
#   vpc_id                = var.vpc_id
  
#   health_check {
#     enabled             = true
#     healthy_threshold   = var.health_threshold
#     interval            = var.health_interval
#     matcher             = var.health_matcher
#     path                = format("%sapi/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/", var.health_path)
#     port                = var.health_port
#     protocol            = var.health_protocol
#     timeout             = var.health_timeout
#     unhealthy_threshold = var.health_unthreshold
#   }

#   tags = {
#     Name = "Gitfolio lb k8s target group"
#   }
# }

# resource "aws_lb_target_group_attachment" "k8s" {
#   target_group_arn = aws_lb_target_group.k8s.arn
#   target_id        = var.k8s_id
# }