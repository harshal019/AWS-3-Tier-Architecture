resource "aws_lb" "external_alb" {
  name               = "${var.project}-${var.env}-external-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  
}

// Web Target Group

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project}-${var.env}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

// External Listener

resource "aws_lb_listener" "external_http" {
  load_balancer_arn = aws_lb.external_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}



resource "aws_lb" "internal_alb" {
  name               = "${var.project}-${var.env}-internal-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [var.internal_alb_sg_id]
  subnets         = var.private_subnets
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project}-${var.env}-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}