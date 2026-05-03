variable "project" {}
variable "env" {}
variable "instance_class" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "private_subnets" {
  type = list(string)
}

variable "db_sg_id" {}