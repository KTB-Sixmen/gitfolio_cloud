resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 50000  // 다른 서비스들과 겹치지 않는 우선순위 사용

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins", "/jenkins/*"]  // /jenkins 하위의 모든 경로를 Jenkins로 라우팅
    }
  }

  condition {
    host_header {
      values = ["dev.gitfolio.site"]
    }
  }

  tags = {
    Name = "Gitfolio Jenkins routing"
  }
}

resource "aws_lb_target_group" "jenkins" {
  name                  = "gitfolio-jenkins-tg"
  port                  = 8080  // Jenkins의 기본 포트
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.health_threshold
    interval            = var.health_interval
    matcher             = "200,302,403"  // Jenkins는 로그인 페이지로 리다이렉트할 수 있으므로 302도 허용
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

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = var.jenkins_id  // Jenkins 인스턴스 ID
}