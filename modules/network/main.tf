#VPC

resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr_block
    tags = {
        Name="myvpc"
    }
}

#Subnets Public1

resource "aws_subnet" "main_subnet_public" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "mysubnet1_public"
  }
}

#Subnets Public2

resource "aws_subnet" "main_subnet_public1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr1
  availability_zone = "us-east-1b"

  tags = {
    Name = "mysubnet2_public"
  }
}

#Subnet Private
resource "aws_subnet" "main_subnet_private" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1c"

  tags = {
    Name = "mysubnet2_private"
  }
}



# Securirty Groups

resource "aws_security_group" "my_security_group" {
  name_prefix = "my-secg-"
  vpc_id     = aws_vpc.main_vpc.id

  // Inbound rule for PostgreSQL (5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"] 
  }

  // Inbound rule for SSH (22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]  
  }

  // Inbound rule for HTTP (80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"] 
  }

  // Inbound rule for HTTPS (443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]  
  } 
}


# Define an AWS_ECS security group
# resource "aws_security_group" "myecs_security_group" {
#   name_prefix = "myecs-security-group"
#   vpc_id     = aws_vpc.main_vpc.id

  # security group rules
 
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#     // Inbound rule for HTTPS (443)
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }
#   // Inbound rule for SSH (22)
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }

#    // Inbound rule for PostgreSQL (5432)
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#   }
# }


# Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "myinternetgw"
  }
}




# Creation route-table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name="my_public_rt"
  }

  
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name="my_private_rt"
  }

  
}

resource "aws_route_table" "public_rt1" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name="my_public_rt1"
  }
 
}

  #Route Table Association

  resource "aws_route_table_association" "pubicroute_a" {
  subnet_id      = aws_subnet.main_subnet_public.id 
  route_table_id = aws_route_table.public_rt.id
}

 
resource "aws_route_table_association" "privateroute_a" {
  subnet_id      = aws_subnet.main_subnet_private.id
  route_table_id = aws_route_table.private_rt.id
}


  resource "aws_route_table_association" "pubicroute_a1" {
  subnet_id      = aws_subnet.main_subnet_public1.id 
  route_table_id = aws_route_table.public_rt1.id
}




