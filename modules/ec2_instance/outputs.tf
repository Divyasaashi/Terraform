output "public_ip" {
value = aws_instance.project.public_ip
}

output "instance_id" {
value = aws_instance.project.id
}
