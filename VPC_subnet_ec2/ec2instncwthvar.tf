/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" 
   # apni region ka dhyaan rakho
}
*/
# -------------------------
# Create Key Pair
# -------------------------
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key"
  public_key = file("/home/swati_gupta/system_key/terra-key.pub")
  
}

# -------------------------
# Create VPC
# -------------------------
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
   enable_dns_support   = true
  enable_dns_hostnames= true

  tags = {
    Name = "my_vpc"
  }
}

# -------------------------
# Create Internet Gateway
# -------------------------
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# -------------------------
# Create Route Table
# -------------------------
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

# -------------------------
# Create Public Subnet
# -------------------------
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.azs[0]

  tags = {
    Name = "my_subnet"
  }
}

# -------------------------
# Associate Route Table with Subnet
# -------------------------
resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# -------------------------
# Create Security Group
# -------------------------
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "SG for EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id
}

# Ingress: HTTP
resource "aws_vpc_security_group_ingress_rule" "inbound_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Ingress: SSH
resource "aws_vpc_security_group_ingress_rule" "inbound_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Egress: Allow All
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# -------------------------
# Create EC2 Instance
# -------------------------
resource "aws_instance" "my_ec2" {
  ami                         = var.ec2_ami_id # Mumbai region Amazon Linux 2
  instance_type               = var.ec2_instance_type
 availability_zone = var.azs[0]
  key_name                    = aws_key_pair.my_key.key_name
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  ##user_data = file("install_nginx.sh")
  count = 2

  root_block_device {
    volume_size = var.ec2_block_size
    volume_type = "gp3"
  }
}
