provider "aws" {
region = "ap-south-1"
}

resource "aws_vpc" "vpc_project" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc_project"
  }
}

resource "aws_subnet" "Public_Subnet" {
  cidr_block = var.pub_cidr
  vpc_id = aws_vpc.vpc_project.id
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_subnet" "Private_Subnet" {
  cidr_block = var.pri_cidr
  vpc_id = aws_vpc.vpc_project.id
  availability_zone = var.availability_zone
  tags = {
    Name = "Private_Subnet"
  }
}

resource "aws_internet_gateway" "IGW" {
  tags = {
    Name = "IGW"
  }
  vpc_id = aws_vpc.vpc_project.id
}

resource "aws_nat_gateway" "NAT" {
  subnet_id = aws_subnet.Public_Subnet.id
  allocation_id = aws_eip.ELIP.id
}

resource "aws_eip" "ELIP" {
 domain = "vpc"
}

resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.vpc_project.id
  tags = {
    Name = "Public_Route_Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table" "Private_Route_Table" {
  vpc_id = aws_vpc.vpc_project.id
  tags = {
    Name = "Private_Route_Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}

resource "aws_route_table_association" "Public_Subnet_Asso" {
  subnet_id = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.Public_Route_Table.id
}

resource "aws_route_table_association" "Private_Subnet_Asso" {
  subnet_id = aws_subnet.Private_Subnet.id
  route_table_id = aws_route_table.Private_Route_Table.id
}

resource "aws_security_group" "Internet_LB" {
  vpc_id = aws_vpc.vpc_project.id 
  name = "Internet_LB"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "Internal_LB" {
  vpc_id = aws_vpc.vpc_project.id
  name = "Internal_Lb"
}

resource "aws_security_group_rule" "internal_from_internet" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.Internal_LB.id
  source_security_group_id = aws_security_group.Internet_LB.id
}

resource "aws_security_group" "DB_SG" {
  vpc_id = aws_vpc.vpc_project.id
  name = "DB_SG"
}

resource "aws_security_group_rule" "db_from_internal" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.DB_SG.id
  source_security_group_id = aws_security_group.Internal_LB.id
}
