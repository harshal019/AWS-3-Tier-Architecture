output "project_name" {
  value = var.project
}

output "internal_alb_dns" {
  value = module.alb.internal_alb_dns
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "external_alb_dns" {
  value = module.alb.external_alb_dns
}


