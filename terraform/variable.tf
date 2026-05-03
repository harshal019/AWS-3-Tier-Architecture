variable "project" {
    default = "3tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}