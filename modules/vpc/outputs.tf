output "vpc_id" {
value = aws_vpc.vpc_project.id
}

output "public_subnet_ids" {
value = aws_subnet.Public_Subnet.id
}

output "security_group_ids" {
value = aws_security_group.Internet_LB.id
}
