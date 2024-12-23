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
  port     = 31258 // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
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

resource "aws_lb_listener_rule" "master" {
  listener_arn = var.listener_arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.master.arn
  }

  condition {
    path_pattern {
      values = ["/master", "/master/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio k8s master routing"
  }
}

resource "aws_lb_target_group" "master" {
  name     = "gitfolio-master-tg"
  port     = var.target_port["k8s"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = "/master/healthz"
    port                = var.health_port
    protocol            = "HTTPS"
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio k8s master target group"
  }
}

resource "aws_lb_target_group_attachment" "master" {
  target_group_arn = aws_lb_target_group.master.arn
  target_id        = var.master_id
}
