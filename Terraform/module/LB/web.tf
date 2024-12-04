resource "aws_lb_listener_rule" "auth_routing" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_auth.arn
  }

  condition {
    path_pattern {
      values = ["/oauth2/*", "/login/*"]
    }
  }

  tags = {
    Name = "Gitfolio auth path based routing"
  }
}

resource "aws_lb_target_group" "alb_auth" {
  name                  = "gitfolio-auth-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%slogin", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb auth module target group"
  }
}

resource "aws_lb_target_group_attachment" "backend_auth" {
  target_group_arn = aws_lb_target_group.alb_auth.arn
  target_id        = var.backend_auth_id
}

// =====================================================================

resource "aws_lb_listener_rule" "ai_routing" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ai.arn
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  condition {
    path_pattern {
      values = ["/docs/*", "/docs", "/openapi.json"]
    }
  }

  tags = {
    Name = "Gitfolio ai host header based routing"
  }
}

resource "aws_lb_target_group" "alb_ai" {
  name                  = "gitfolio-ai-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = var.health_path
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb ai target group"
  }
}

resource "aws_lb_target_group_attachment" "ai" {
  target_group_arn = aws_lb_target_group.alb_ai.arn
  target_id        = var.ai_id
}