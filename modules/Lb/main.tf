# Load Balancer Config:

#  Application Load Balancer
resource "aws_lb" "ecs_lb" {
  name               = "ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.myecs_security_group.id]
  subnets            = [aws_subnet.main_subnet_public1.id, aws_subnet.main_subnet_public.id]

  enable_deletion_protection = false  
}

# Create a target group for the ECS service

resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip" 
  health_check {
    path = "/"
  }
}

#____________________________________________________________________________________________________________________________________________________________________________________-

# Attach the target group to the load balancer listener

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

