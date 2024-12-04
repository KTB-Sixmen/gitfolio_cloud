resource "aws_lb_listener_rule" "bot_routing" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 40000

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_bot.arn
  }

  condition {
    host_header {
      values = ["api.gitfolio.site"]
    }
  }

  condition {
    path_pattern {
      values = ["/webhook/sentry", "/health", "/health/detailed"]
    }
  }

  tags = {
    Name = "Gitfolio sentry bot path based routing"
  }
}

resource "aws_lb_target_group" "alb_bot" {
  name                  = "gitfolio-bot-tg"
  port                  = var.target_port["fastapi"]      // LB가 타겟으로 트래픽을 전달하는 포트(ALB->target(instance))
  protocol              = var.target_protocol
  vpc_id                = var.vpc_id
  
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

resource "aws_lb_target_group_attachment" "bot" {
  target_group_arn = aws_lb_target_group.alb_bot.arn
  target_id        = var.frontend_id
}