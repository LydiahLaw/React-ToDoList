# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"

#   }
# }

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"

#   name = "single-instance"

#   instance_type = "t3.micro"
#   key_name      = "wtf_key"
#   monitoring    = true
#   subnet_id     = module.vpc.public_subnets[0]

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }



locals {
  # normalized workspace name
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  # base app/project name
  project = "wtf"

  # standard prefix pattern for all resources
  prefix = "${local.project}-${local.environment}"
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # backend "s3" {
  #   bucket = "wtf_bucket"
  #   key = "wtf-app/terraform.tfstate"
  # }
}


resource "aws_s3_bucket" "wtf_bucket" {
  bucket = "wtfbucket16"
  tags = {
    name = "${local.prefix}-bucket"
  }
}


module "vpc-modules" {

  source            = "./vpc-modules"
  region            = var.region
  vpc_cidr_block    = var.vpc_cidr_block
  az                = var.az
  subnet_cidr_block = var.subnet_cidr_block

}


module "ec2-modules" {
  source        = "./ec2-modules"
  instance_type = var.instance_type
  region        = var.region
  az            = var.az
  vpc_id        = module.vpc-modules.vpc_id
  subnet_id = module.vpc-modules.subnet_id
}




resource "aws_instance" "wtf_server1" {
  instance_type = "t3.micro"
  ami = "ami-03deb8c961063af8c"
 region         = "us-east-1"
}