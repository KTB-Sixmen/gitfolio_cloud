resource "aws_lb_listener_rule" "ingress" {
  listener_arn = var.listener_arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }

  condition {
    host_header {
      values = ["www.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio k8s ingress routing"
  }
}

resource "aws_lb_target_group" "ingress" {
  name     = "gitfolio-ingress-tg"
  port     = var.target_port["NodePort"] + var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%shealthz", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio k8s ingress target group"
  }
}

resource "aws_lb_target_group_attachment" "ingress" {
  target_group_arn = aws_lb_target_group.ingress.arn
  target_id        = var.ingress_id
}

// ============================================================================================================

# resource "aws_lb_listener_rule" "oauth2" {
#   listener_arn = var.listener_arn
#   priority     = 2

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ingress.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/oauth2/*", "/login/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["www.gitfolio.site"]
#     }
#   }

#   tags = {
#     Name = "Gitfolio oauth2 routing"
#   }
# }

// ============================================================================================================

resource "aws_lb_listener_rule" "api" {
  listener_arn = var.listener_arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio k8s api routing"
  }
}

// ============================================================================================================

resource "aws_lb_listener_rule" "grafana" {
  listener_arn = var.listener_arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress.arn
  }

  condition {
    host_header {
      values = ["grafana.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio k8s grafana routing"
  }
}
