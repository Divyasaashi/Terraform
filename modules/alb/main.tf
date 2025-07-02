resource "aws_lb" "external_lb" {
   tags = {
    Name = "external-lb"
   }
   load_balancer_type = "application"
   internal = false
   subnets = var.subnet_ids
   security_groups = var.security_group_ids
}

resource "aws_lb_target_group" "external_tar" {
  name = "external-tar"
  protocol = "HTTP"
  port = 80
  vpc_id = var.vpc_id
  
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

resource "aws_lb_listener" "external_lb_lis" {
  load_balancer_arn = aws_lb.external_lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.external_tar.arn
  }
}

resource "aws_lb_target_group_attachment" "external_attach" {
  target_group_arn = aws_lb_target_group.external_tar.arn
  port = 80
  target_id = var.instance_id
}
