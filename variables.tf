variable "ami" {
  description = "ami value"
}
variable "instance_type" {
  description = "instance_type"
}
variable "security_groups" {
  description = "security"
}
variable "key_name" {
  description = "key_name"
}
variable "tags" {
  description = "tags"
} 

variable "vpc_cidr" {
description ="instance_type"
}
variable "pri_cidr" {
description = "security"
}
variable "pub_cidr" {
description  = "key"
}
variable "availability_zone" {
description = "tags"
}
