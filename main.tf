provider "aws" {
region = "ap-south-1"
}

module "ec2_modo" {
source = "./modules/ec2_instance"
ami = var.ami
instance_type = var.instance_type
security_groups = var.security_groups
key_name = var.key_name
tags ={
Name = var.tags
}
}

module "vpc_modo" {
source = "./modules/vpc"
vpc_cidr = var.vpc_cidr
pub_cidr = var.pub_cidr
pri_cidr = var.pri_cidr
availability_zone = var.availability_zone
}

module "elb_modo" {
source = "./modules/load_balancer"
vpc_id = module.vpc_modo.vpc_id
subnet_ids = [module.vpc_modo.public_subnet_ids]
security_group_ids = [module.vpc_modo.security_group_ids]
instance_id = module.ec2_modo.instance_id
}
