

##########################################
# VPC
##########################################
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

##########################################
# Internet Gateway
##########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

##########################################
# Public Subnet
##########################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}

##########################################
# Route Table
##########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

##########################################
# Route: Internet Access
##########################################
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

##########################################
# Route Table Association
##########################################
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

##########################################
# Network ACL
##########################################
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "public-nacl"
  }
}

# Allow inbound HTTP, HTTPS, SSH, and ephemeral ports
resource "aws_network_acl_rule" "inbound_allow" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Allow outbound everything
resource "aws_network_acl_rule" "outbound_allow" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  egress         = true
}

# Associate NACL to subnet
resource "aws_network_acl_association" "nacl_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.public_nacl.id
}

##########################################
# Security Group
##########################################
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and web traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

##########################################
# EC2 Instance
##########################################
resource "aws_instance" "web_server" {
  ami                         = var.ami # Ubuntu 22.04 (us-east-1)
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  

  key_name = "wtf_key" # Replace with your EC2 key pair

  tags = {
    Name = "web-server"
  }
}


