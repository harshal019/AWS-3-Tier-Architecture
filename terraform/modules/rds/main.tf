resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-${var.project}-${var.env}-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.project}-${var.env}-db-subnet"
  }
}




// RDS Instance
resource "aws_db_instance" "db" {
  identifier = "db-${var.project}-${var.env}"

  engine         = "mysql"
  instance_class = var.instance_class

  allocated_storage = 29

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  multi_az = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.db_sg_id]

  publicly_accessible = false

  skip_final_snapshot = true
}


