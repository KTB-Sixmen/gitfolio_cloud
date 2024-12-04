resource "aws_lb_listener_rule" "api_auth" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_auth.arn
  }

  condition {
    path_pattern {
      values = ["/api/auth", "/api/auth/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio frontend api auth routing"
  }
}

resource "aws_lb_target_group" "api_auth" {
  name                  = "gitfolio-api-auth-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%sapi/auth", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb api auth target group"
  }
}

resource "aws_lb_target_group_attachment" "api_auth" {
  target_group_arn = aws_lb_target_group.api_auth.arn
  target_id        = var.backend_auth_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "api_member" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30001

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_member.arn
  }

  condition {
    path_pattern {
      values = ["/api/members", "/api/members/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio frontend api member routing"
  }
}

resource "aws_lb_target_group" "api_member" {
  name                  = "gitfolio-api-member-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%sapi/members", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb api member target group"
  }
}

resource "aws_lb_target_group_attachment" "api_member" {
  target_group_arn = aws_lb_target_group.api_member.arn
  target_id        = var.backend_auth_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "api_resume" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30002

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_resume.arn
  }

  condition {
    path_pattern {
      values = ["/api/resumes-back", "/api/resumes-back/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio frontend api resume routing"
  }
}

resource "aws_lb_target_group" "api_resume" {
  name                  = "gitfolio-api-resume-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%sapi/resumes-back", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb api resume target group"
  }
}

resource "aws_lb_target_group_attachment" "api_resume" {
  target_group_arn = aws_lb_target_group.api_resume.arn
  target_id        = var.backend_resume_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "api_notification" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30003

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_notification.arn
  }

  condition {
    path_pattern {
      values = ["/api/notifications", "/api/notifications/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio frontend api notification routing"
  }
}

resource "aws_lb_target_group" "api_notification" {
  name                  = "gitfolio-api-notification-tg"
  port                  = var.target_port["http"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%sapi/notifications", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb api notification target group"
  }
}

resource "aws_lb_target_group_attachment" "api_notification" {
  target_group_arn = aws_lb_target_group.api_notification.arn
  target_id        = var.backend_notification_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "api_ai" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30004

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_ai.arn
  }

  condition {
    path_pattern {
      values = ["/api/resumes", "/api/resumes/*"]
    }
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio ai api routing"
  }
}

resource "aws_lb_target_group" "api_ai" {
  name                  = "gitfolio-api-ai-tg"
  port                  = var.target_port["https"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
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
    Name = "Gitfolio lb api ai target group"
  }
}

resource "aws_lb_target_group_attachment" "api_ai" {
  target_group_arn = aws_lb_target_group.api_ai.arn
  target_id        = var.ai_id
}