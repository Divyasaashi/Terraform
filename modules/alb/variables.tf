variable "vpc_id" {
description = "vpc id"
}
variable "security_group_ids" {
description = "security_groups"
}
variable "subnet_ids" {
description = "subnet id"
type = list(string)
}
variable "instance_id" {
description = "instance - id"
}
