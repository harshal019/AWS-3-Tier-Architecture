variable "project"{}

variable "env"{}

variable "vpc_id" {}

variable "public_subnets"{
    type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "alb_sg_id" {}
variable "internal_alb_sg_id" {}