#ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}


resource "aws_security_group" "myecs_security_group" {
  name_prefix = "myecs-security-group"
  vpc_id     = var.cidr_block.id

  # security group rules
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    // Inbound rule for HTTPS (443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  // Inbound rule for SSH (22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

   // Inbound rule for PostgreSQL (5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}


# Define an IAM role for ECS task execution
resource "aws_iam_role" "myecss_execution_role" {
  name = "myecss-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}



#  ECS task definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.myecss_execution_role.arn

 #container definition 
  container_definitions = jsonencode([
    {
      name = "my-container"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
      essential = true
      # cpu=256
      memory = 512
      network_mode = "awsvpc"  # Network mode should be specified within the container definition

      network_configuration = {
        subnets = [aws_subnet.main_subnet_public1.id, aws_subnet.main_subnet_public.id]
        security_groups = [aws_security_group.myecs_security_group.id]
      }
    }
  ])
}

# Define an ECS service
resource "aws_ecs_service" "example_service" {
  name            = "ecs-service"
  cluster         =aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "EC2"
  desired_count = 2
 
  network_configuration  {
    subnets         = [aws_subnet.main_subnet_public1.id, aws_subnet.main_subnet_public.id]  # Use the subnets relevant to your setup
    security_groups = [aws_security_group.myecs_security_group.id]
  }
   enable_ecs_managed_tags = true
#______________________________________________________________________________________________________________________________________________________________________________________
    load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "my-container"  # Specify the container name from your ECS task definition
    container_port   = 80  # Specify the container port from your ECS task definition
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix          = "ecs-launch"
  image_id             = var.ami  # Specify a valid AMI ID
  instance_type        = var.instance_type  # Specify the instance type you want to use
  security_groups      = [aws_security_group.myecs_security_group.id]
  key_name             = "bookstore us-east-1"
  associate_public_ip_address = true
  user_data = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.my_cluster.name} >> /etc/ecs/ecs.config"
# user_data = !/bin/bash echo "ECS_CLUSTER=example-cluster" >> /etc/ecs/ecs.config


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "service_policy_attachment" {
  role       = aws_iam_role.myecss_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_autoscaling_group" "ecs_autoscale_group" {
  name_prefix          = "ecs-autoscale-group-"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  min_size             = 1  # Minimum number of instances
  max_size             = 3  # Maximum number of instances
  desired_capacity     = 1  # Initial number of instances
  vpc_zone_identifier  = [var.public_subnet_cidr1.id, var.public_subnet_cidr.id]  # Use your public subnets

  tag {
    key                 = "Name"
    value               = "ECS_Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
