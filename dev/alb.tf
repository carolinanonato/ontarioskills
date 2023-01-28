#smol test

resource "aws_lb" "this" {
  name               = "${var.name}-alb-${var.stage}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.ecs_sg.id]
  subnets            = module.dynamic_subnets.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-alb-${var.stage}"
    Environment = var.stage
  }
}
# ALB is deployed
resource "aws_alb_target_group" "this" {
  name        = "${var.name}-tg-${var.stage}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.stage}"
    Environment = var.stage
  }

  depends_on = [aws_lb.this]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.this.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }
}
