terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "bucket.tfstate"
    key    = "tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "my_subnets" {
 for_each          = var.my_subnets
 vpc_id            = aws_vpc.my_vpc.id
 cidr_block        = each.value.cidr
 availability_zone = each.value.az
 map_public_ip_on_launch = each.value.map_public_ip_on_launch
 
 tags = {
   Name = "Subnet - ${each.value.msg}"
 }

}

resource "aws_internet_gateway" "my_vpc_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC"
  }
}

resource "aws_route_table" "my_vpc_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_gw.id
  }

  tags = {
    Name = "My VPC"
  }
}

resource "aws_route_table_association" "my_vpc_route_table_association" {
  for_each  = aws_subnet.my_subnets
  subnet_id = each.value.id
  route_table_id = aws_route_table.my_vpc_route_table.id
}

resource "aws_security_group" "server_sg" {
    vpc_id = aws_vpc.my_vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    //If you do not add this rule, you can not reach the NGIX
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web1" {
    instance_type = "t2.micro"
    ami = "ami-01b20f5ea962e3fe7"
    # Security Group
    vpc_security_group_ids = [aws_security_group.server_sg.id]

    user_data = <<EOF
      #!/bin/bash
      sudo su
      yum -y update
      yum install -y httpd
      systemctl enable httpd
      systemctl start httpd
      echo 'Hello World' > /var/www/html/index.html
    EOF
    key_name = "rahul"
    subnet_id = aws_subnet.my_subnets["my_subnet1"].id
}
