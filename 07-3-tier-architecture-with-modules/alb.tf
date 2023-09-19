

resource "aws_lb" "this" {
  name               = "web-alb-${terraform.workspace}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet.*.id #==[for i in aws_subnet.public_subnet:i.id]

  tags = {
    Environment = "web-alb-${terraform.workspace}"
  }
}

######################################
# Load balancer target group
######################################
resource "aws_lb_target_group" "app1" {
  name        = "app1-tg-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/app1/index.html"
    matcher             = "200-399"
    port                = "traffic-port"
  }
}


resource "aws_lb_target_group" "app2" {
  name        = "app2-tg-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/app2/index.html"
    matcher             = "200-399"
    port                = "traffic-port"
  }
}

resource "aws_lb_target_group" "registration_app" {
  name        = "registration-app-tg-${terraform.workspace}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/login"
    matcher             = "200-399"
    port                = "traffic-port"
  }
}

##################################
# Load balancer group attachment
###################################
resource "aws_lb_target_group_attachment" "app1" {
  target_group_arn = aws_lb_target_group.app1.arn
  target_id        = aws_instance.app1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app2" {
  target_group_arn = aws_lb_target_group.app2.arn
  target_id        = aws_instance.app2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "registration_app" {
  count = length(aws_instance.registration_app) #2

  target_group_arn = aws_lb_target_group.registration_app.arn
  target_id        = aws_instance.registration_app[count.index].id
  port             = 8080
}

####################
#listner redirect
####################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
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

################################
# Listener forward
#################################
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}
##############################
#LISTNER RULES
##############################
resource "aws_lb_listener_rule" "app1" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }

  condition {
    path_pattern {
      values = [
        "/app1*"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "app2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2.arn
  }

  condition {
    path_pattern {
      values = [
        "/app2*"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "registration_app" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.registration_app.arn
  }

  condition {
    path_pattern {
      values = [
        "/*"
      ]
    }
  }
}

data "aws_route53_zone" "this" {
  name = var.dns_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.dns_name #www.renniemukete.click
  type    = "A"          #c-name or a-record

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "this" {
  domain_name               = data.aws_route53_zone.this.name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

resource "aws_route53_record" "example" {
  for_each = {

    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}
