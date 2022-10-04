##############################
# Create Load Balancers
##############################

######
# NLB
######

resource "aws_lb" "nlb" {
  name                             = "${var.this["appname"]}${var.this["env"]}-nlb"
  internal                         = true
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id            = data.aws_subnet.transport_a.id
    private_ipv4_address = var.this["nlb_ip_a"]
  }

  subnet_mapping {
    subnet_id            = data.aws_subnet.transport_b.id
    private_ipv4_address = var.this["nlb_ip_b"]
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.this["env"]}"
    Name        = "${var.this["appname"]}${var.this["env"]}-nlb"
  }
}

######
# ALB
######

resource "aws_lb" "alb" {
  name                             = "${var.this["appname"]}${var.this["env"]}-alb"
  internal                         = true
  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields = true
  load_balancer_type               = "application"
  security_groups                  = [data.aws_security_group.outbound_only.id, data.aws_security_group.cmscloud_shared_services.id, data.aws_security_group.transport_sg.id]


  subnet_mapping {
    subnet_id = data.aws_subnet.transport_a.id
  }

  subnet_mapping {
    subnet_id = data.aws_subnet.transport_b.id
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.this["env"]}"
    Name        = "${var.this["appname"]}${var.this["env"]}-alb"
  }
}

##############################
# Listeners
##############################

######
# NLB
######

resource "aws_lb_listener" "nlb_443" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group._443.arn
  }
}

######
# ALB
######

resource "aws_lb_listener" "alb_443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group._80.arn
  }
}

##############################
# Target Groups
##############################

resource "aws_lb_target_group" "_443" {
  name        = "443"
  port        = 443
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.custom.id
  target_type = "alb"

  stickiness {
    enabled = true
    type    = "source_ip"
  }

  health_check {
    port     = 443
    protocol = "HTTPS"
  }
  lifecycle {
    ignore_changes = [stickiness]
  }
}

resource "aws_lb_target_group" "_80" {
  name        = "80"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.custom.id
  target_type = "instance"

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = true
    type    = "lb_cookie" #app_cookie or lb_cookie
    # cookie_name = "cookiename"
    cookie_duration = 86400
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }

  depends_on = [
    aws_lb.alb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

##############################
# Attachements
##############################

resource "aws_lb_target_group_attachment" "_443" {
  target_group_arn = aws_lb_target_group._443.arn
  target_id        = aws_lb.alb.arn
  depends_on       = [aws_lb_listener.alb_443]
}
