output "web_asg_name" {
  value = aws_autoscaling_group.web_asg.name
}

output "app_asg_name" {
  value = aws_autoscaling_group.app_asg.name
}