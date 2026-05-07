#!/bin/bash
set -e

# Activate venv

cd terraform

terraform init 
terraform apply -auto-approve

echo "🔍 Fetching Terraform Outputs..."

ALB_DNS=$(terraform output -raw internal_alb_dns)
export  ALB_DNS=$(terraform output -raw internal_alb_dns)

DB_ENDPOINT=$(terraform output -raw db_endpoint)

cd ../ansible

ansible-playbook -i inventory/aws_ec2.yml playbooks/app.yml \
  -e "db_endpoint=$DB_ENDPOINT"

ansible-playbook -i inventory/aws_ec2.yml playbooks/web.yml \
  -e "internal_alb_dns=$ALB_DNS"

echo "✅ Deployment Complete!"