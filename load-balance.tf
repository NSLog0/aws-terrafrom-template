data "aws_acm_certificate" "cert" {
  domain   = "example.site.com"
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_security_group" "m1_lb_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "m1_alb" {
  name               = "${terraform.workspace}-m1-alb"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default_subnet.ids
  security_groups = [aws_security_group.m1_lb_security_group.id]
  idle_timeout = 300
}

resource "aws_lb_target_group" "m1_lb_http_target_group" {
  name        = "${terraform.workspace}-m1-lb-http-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default_vpc.id

  health_check {
    matcher  = "200,301,302,201"
    path     = "/health"
    interval = "300"
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_alb.m1_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.m1_lb_http_target_group.arn
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_alb.m1_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  } 
}
