locals {
  # normalized workspace name
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  # base app/project name
  project     = "wtf"

  # standard prefix pattern for all resources
  prefix      = "${local.project}-${local.environment}"
}




resource "aws_vpc" "wtf_vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support= true
    enable_dns_hostnames= true
    tags = {
      name= "${local.prefix}-vpc"
    }
  }


  resource "aws_subnet" "wtf_subnet" {
    region = var.region
    vpc_id = aws_vpc.wtf_vpc.id
    availability_zone = var.az
    cidr_block = var.subnet_cidr_block
    map_public_ip_on_launch= true
  }

  resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.wtf_vpc.id

  tags = {
    Name = "${local.prefix}-igw"
  }
}


resource "aws_route_table" "wtf_rt" {
  vpc_id = aws_vpc.wtf_vpc.id

  route {
     cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "${local.prefix}-rt"
  }
}


# resource "aws_route" "wtf_routes" {
#   route_table_id            = aws_route_table.wtf_rt.id
#    destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.gw.id

# }
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.wtf_subnet.id
  route_table_id = aws_route_table.wtf_rt.id
}


