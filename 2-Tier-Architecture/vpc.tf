resource "aws_vpc" "Custom-vpc" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"

   tags = {
     Name = "Customvpc"
   }
}

// creating a Public subnets
resource "aws_subnet" "Public_subnet-1" {
  vpc_id = aws_vpc.Custom-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1"

  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "Public_subnet-2" {
  vpc_id = aws_vpc.Custom-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.Custom-vpc.id
    
    tags = {
      Name = "My_Internet_Gateaway"
    }
}

resource "aws_eip" "custom_eip" {
  vpc = true
}

#Create a NAT gateway and associate it with an Elastic IP and a public subnet
resource "aws_nat_gateway" "custom_nat_gateway" {
  allocation_id = aws_eip.custom_eip.id
  subnet_id = aws_subnet.Public_subnet-2.id
}

#creating NAT route
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.Custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_nat_gateway.id
  }

  tags = {
    Name = "custom-nat-gateaway"
  }
}

resource "aws_subnet" "Private_subnet-1" {
    vpc_id = aws_vpc.Custom-vpc.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-northeast-1"
    map_public_ip_on_launch = false

    tags = {
      Name = "Private_subnet-1"
    }
}

resource "aws_subnet" "Private_subnet-2" {
    vpc_id = aws_vpc.Custom-vpc.id 
    cidr_block = "10.0.4.0/24"
    availability_zone = "ap-northeast-1"
    map_public_ip_on_launch = false

    tags = {
      Name = "Private_subnet-2"
    }
}

#creating database RDS
resource "aws_db_subnet_group" "My-custom-subgroup" {
    name = "my-custom-subgroup"
    subnet_ids = [aws_subnet.Private_subnet-1.id, aws_subnet.Private_subnet-2.id]
    tags = {
      Name = "My database subnet group"
    }
}

resource "aws_route_table_association" "private_route_table_ass_1" {
  subnet_id = aws_subnet.Private_subnet-1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_ass_2" {
  subnet_id = aws_subnet.Private_subnet-2.id
  route_table_id = aws_route_table.private_route_table.id
}

// creating a security groups
resource "aws_security_group" "My-SG" {
  name = "My-SG"
  description = "security group for load balancer"
  vpc_id = aws_vpc.Custom-vpc.id

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port =  "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.custom_nat_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_ass_1" {
  subnet_id = aws_subnet.Public_subnet-1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_ass_2" {
  subnet_id = aws_subnet.Public_subnet-2.id
  route_table_id = aws_route_table.public_route_table.id
}

// creating a public security group
resource "aws_security_group" "custom_security_SG_DB" {
  name        = "Custom-Public-SG-DB"
  description = "web and SSH allowed"
  vpc_id      = aws_vpc.Custom-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating a loadbalancer
resource "aws_lb" "My-lb" {
  name               = "My-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.Public_subnet-1.id, aws_subnet.Public_subnet-2.id]
  security_groups    = [aws_security_group.My-SG.id]
}

#creating load balancer target group
resource "aws_lb_target_group" "My-lb-tg" {
  name     = "Customtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Custom-vpc.id

  depends_on = [aws_vpc.Custom-vpc]
}

#creating load balancer target group
resource "aws_lb_target_group_attachment" "My-target-group1" {
  target_group_arn = aws_lb_target_group.My-lb-tg.arn
  target_id        = aws_instance.My-web-instance1.id
  port             = 80

  depends_on = [aws_instance.My-web-instance1]
}
#creating load balancer target group
resource "aws_lb_target_group_attachment" "My-target-group2" {
  target_group_arn = aws_lb_target_group.My-lb-tg.arn
  target_id        = aws_instance.My-web-instance2.id
  port             = 80

  depends_on = [aws_instance.My-web-instance2]
}
#creating load balancer listener
resource "aws_lb_listener" "My-listener" {
  load_balancer_arn = aws_lb.My-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.My-lb-tg.arn
  }
}
