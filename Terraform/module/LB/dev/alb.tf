resource "aws_lb" "alb" {
  name               = "gitfolio-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.security_group_ids["base"]]
  subnets            = var.public_subnet_ids
  idle_timeout       = var.idle_timeout

  enable_deletion_protection = var.delete_protection

  tags = {
    Name = "Gitfolio ${terraform.workspace} load balancer"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80 // 클라이언트가 LB에 접근하는 포트(클라이언트->LB)
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "Gitfolio HTTP listner"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443 // 클라이언트가 LB에 접근하는 포트(클라이언트->LB)
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = data.aws_acm_certificate.gitfolio_issued.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid host"
      status_code  = "404"
    }
  }

  tags = {
    Name = "Gitfolio HTTPS listner"
  }
}
