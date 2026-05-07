variable "project" {}
variable "env" {}

variable "web_sg_id" {}
variable "app_sg_id" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "web_tg_arn" {}
variable "app_tg_arn" {}


variable "ami_id" {}

variable "instance_type" {}


variable "key_name" {
  type = string
}

variable "instance_profile_name" {}