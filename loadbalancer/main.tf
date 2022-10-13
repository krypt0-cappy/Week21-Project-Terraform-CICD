#---loadbalancer/main.tf---

# LOADBALANCER
resource "aws_lb" "krypt0_21_loadbalancer" {
  name               = "krypt0-21-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_server_sg]
  subnets            = tolist(var.public_subnet)

  depends_on = [
    var.krypt0_21_webserver_asg
  ]
}

# LOADBALANCER TARGET GROUP
resource "aws_lb_target_group" "krypt0_21_target_group" {
  name     = "krypt0-loadbalancer-tg-${substr(uuid(), 0, 3)}"
  protocol = var.target_group_protocol
  port     = var.target_group_port
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  health_check {
    healthy_threshold   = var.lb_healthy_threshold   #2
    unhealthy_threshold = var.lb_unhealthy_threshold #2
    timeout             = var.lb_timeout             #3
    interval            = var.lb_interval            #30
  }
}

# LOADBALANCER LISTENER
resource "aws_lb_listener" "krypt0_21_loadbalancer_listener" {
  load_balancer_arn = aws_lb.krypt0_21_loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.krypt0_21_target_group.arn
  }
}