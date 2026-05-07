// ALB → Target Group → EC2 (created by Auto Scaling)



resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.project}-${var.env}-web"
  image_id      = var.ami_id   # replace with valid AMI
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }
  key_name = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.web_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project}-${var.env}-web-server"
      Role = "web"
      Env  = var.env
    }
  }
}



resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 3
  max_size         = 5
  min_size         = 2

  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.web_tg_arn]
}



resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project}-${var.env}-app"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
     name = var.instance_profile_name
  }

  key_name = var.key_name

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y nodejs
              EOF
  )

  tag_specifications {
  resource_type = "instance"

  tags = {
    Name = "${var.project}-${var.env}-app-server"
    Role = "app"
    Env  = var.env
  }
}
}



resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 3
  max_size         = 5
  min_size         = 2

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.app_tg_arn]
}