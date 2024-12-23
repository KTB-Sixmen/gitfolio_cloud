resource "aws_lb_listener_rule" "dev_https" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 50000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_https.arn
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio ${terraform.workspace} HTTPS listner"
  }
}

resource "aws_lb_target_group" "dev_https" {
  name     = "gitfolio-front-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio lb frontend target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_https" {
  target_group_arn = aws_lb_target_group.dev_https.arn
  target_id        = var.frontend_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_oauth2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49999

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_oauth2.arn
  }

  condition {
    path_pattern {
      values = ["/oauth2/*", "/login/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev oauth2 routing"
  }
}

resource "aws_lb_target_group" "dev_oauth2" {
  name     = "gitfolio-dev-oauth2-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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

resource "aws_lb_target_group_attachment" "dev_oauth2" {
  target_group_arn = aws_lb_target_group.dev_oauth2.arn
  target_id        = var.backend_auth_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_auth" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49998

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_auth.arn
  }

  condition {
    path_pattern {
      values = ["/api/auth", "/api/auth/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev auth routing"
  }
}

resource "aws_lb_target_group" "dev_auth" {
  name     = "gitfolio-dev-auth-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio dev auth target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_auth" {
  target_group_arn = aws_lb_target_group.dev_auth.arn
  target_id        = var.backend_auth_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_member" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49997

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_member.arn
  }

  condition {
    path_pattern {
      values = ["/api/members", "/api/members/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio frontend api member routing"
  }
}

resource "aws_lb_target_group" "dev_member" {
  name     = "gitfolio-dev-member-tg"
  port     = var.target_port["http"] + 1 // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio dev member target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_member" {
  target_group_arn = aws_lb_target_group.dev_member.arn
  target_id        = var.backend_auth_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_resume" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49996

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_resume.arn
  }

  condition {
    path_pattern {
      values = ["/api/resumes", "/api/resumes/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev resume routing"
  }
}

resource "aws_lb_target_group" "dev_resume" {
  name     = "gitfolio-dev-resume-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio dev resume target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_resume" {
  target_group_arn = aws_lb_target_group.dev_resume.arn
  target_id        = var.backend_resume_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_notification" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49995

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_notification.arn
  }

  condition {
    path_pattern {
      values = ["/api/notifications", "/api/notifications/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev notification routing"
  }
}

resource "aws_lb_target_group" "dev_notification" {
  name     = "gitfolio-dev-notification-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio dev notification target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_notification" {
  target_group_arn = aws_lb_target_group.dev_notification.arn
  target_id        = var.backend_notification_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_ai" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49994

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_ai.arn
  }

  condition {
    path_pattern {
      values = ["/api/ai/resumes", "/api/ai/resumes/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev ai routing"
  }
}

resource "aws_lb_target_group" "dev_ai" {
  name     = "gitfolio-dev-ai-tg"
  port     = var.target_port["https"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio dev ai target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_ai" {
  target_group_arn = aws_lb_target_group.dev_ai.arn
  target_id        = var.ai_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_payment" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49993

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_payment.arn
  }

  condition {
    path_pattern {
      values = ["/api/payments", "/api/payments/*"]
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev payment routing"
  }
}

resource "aws_lb_target_group" "dev_payment" {
  name     = "gitfolio-dev-payment-tg"
  port     = var.target_port["http"] + 1 // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%sapi/payments", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio dev payment target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_payment" {
  target_group_arn = aws_lb_target_group.dev_payment.arn
  target_id        = var.backend_resume_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_bot" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49992

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_bot.arn
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  condition {
    path_pattern {
      values = ["/webhook/sentry", "/health", "/health/detailed"]
    }
  }

  tags = {
    Name = "Gitfolio dev sentry bot routing"
  }
}

resource "aws_lb_target_group" "dev_bot" {
  name     = "gitfolio-dev-bot-tg"
  port     = var.target_port["fastapi"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = var.health_matcher
    path                = format("%shealth/detailed", var.health_path)
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb sentry bot target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_bot" {
  target_group_arn = aws_lb_target_group.dev_bot.arn
  target_id        = var.frontend_id
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_jenkins" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49991 // 다른 서비스들과 겹치지 않는 우선순위 사용

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_jenkins.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins", "/jenkins/*"] // /jenkins 하위의 모든 경로를 Jenkins로 라우팅
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio dev Jenkins routing"
  }
}

resource "aws_lb_target_group" "dev_jenkins" {
  name     = "gitfolio-dev-jenkins-tg"
  port     = var.target_port["cicd"] // Jenkins의 기본 포트
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = "200,302,403" // Jenkins는 로그인 페이지로 리다이렉트할 수 있으므로 302도 허용
    path                = "/jenkins/login"
    port                = var.health_port
    protocol            = var.health_protocol
    timeout             = var.health_timeout
    unhealthy_threshold = var.health_unthreshold
  }

  tags = {
    Name = "Gitfolio lb jenkins target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_jenkins" {
  target_group_arn = aws_lb_target_group.dev_jenkins.arn
  target_id        = var.jenkins_id // Jenkins 인스턴스 ID
}

// ==================================================================================================

resource "aws_lb_listener_rule" "dev_ai_swagger" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 49990

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_ai_swagger.arn
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  condition {
    path_pattern {
      values = ["/swagger/*", "/swagger", "/openapi.json"]
    }
  }

  tags = {
    Name = "Gitfolio dev ai swagger routing"
  }
}

resource "aws_lb_target_group" "dev_ai_swagger" {
  name     = "gitfolio-ai-swagger-tg"
  port     = var.target_port["http"] // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

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
    Name = "Gitfolio lb ai swagger target group"
  }
}

resource "aws_lb_target_group_attachment" "dev_ai_swagger" {
  target_group_arn = aws_lb_target_group.dev_ai_swagger.arn
  target_id        = var.ai_id
}
