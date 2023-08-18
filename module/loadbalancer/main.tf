resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_lb" "application" {
  name               = format("%s-%s-lb", var.project, var.env)
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.sg.id]
  subnets            = var.subnet_id


  tags = {}
}
resource "aws_lb_target_group" "target" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }

  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.target.arn
  target_id        = var.instance_id
  port             = var.port
}