output "vpc_id" {
value = module.vpc_modo.vpc_id
}

output "public_ip" {
value = module.ec2_modo.public_ip
}
