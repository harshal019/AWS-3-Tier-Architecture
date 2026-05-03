#!/bin/bash

cd terraform

terraform init 
terraform plan 

# Create infra
terraform apply -auto-approve

echo "🔍 Fetching Terraform Outputs..."

# Get values
ALB_DNS=$(terraform output -raw internal_alb_dns)
DB_ENDPOINT=$(terraform output -raw db_endpoint)

cd ../../ansible

# Configure app
ansible-playbook -i inventory/aws_ec2.yml playbooks/app.yml \
  -e "db_endpoint=$DB_ENDPOINT"

# Configure web
ansible-playbook -i inventory/aws_ec2.yml playbooks/web.yml \
  -e "internal_alb_dns=$ALB_DNS"


echo "✅ Deployment Complete!"