#!/bin/bash
# Manual deployment script for local testing

set -e

echo "🚀 Infrastructure Automation Platform - Manual Deployment"
echo "=========================================================="

# Check prerequisites
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform required but not installed"; exit 1; }
command -v ansible >/dev/null 2>&1 || { echo "❌ Ansible required but not installed"; exit 1; }

echo "✅ Prerequisites checked"

# Terraform deployment
echo "📋 Starting Terraform deployment..."
cd terraform
terraform init -input=false
terraform plan -out=tfplan
echo "⚠️  Review the plan above. Continue? (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    terraform apply tfplan
    terraform output -json > ../infrastructure-outputs.json
    echo "✅ Infrastructure provisioned"
else
    echo "❌ Deployment cancelled"
    exit 1
fi

cd ..

# Generate Ansible inventory
echo "📝 Generating Ansible inventory..."
cd ansible
if command -v jq >/dev/null 2>&1; then
    WEB_IP=$(jq -r '.web_server_ip.value' ../infrastructure-outputs.json)
    MONITORING_IP=$(jq -r '.monitoring_server_ip.value' ../infrastructure-outputs.json)
    
    cat > inventory.ini << EOL
[web]
web-server-001 ansible_host=${WEB_IP} ansible_user=vagrant

[monitoring]  
monitoring-001 ansible_host=${MONITORING_IP} ansible_user=vagrant

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_python_interpreter=/usr/bin/python3
EOL
    echo "✅ Dynamic inventory generated"
else
    echo "⚠️  jq not found. Please update inventory.ini manually"
fi

# Ansible deployment
echo "🔧 Starting Ansible configuration..."
ansible-playbook --check playbook.yml -i inventory.ini
echo "⚠️  Dry-run completed. Execute actual deployment? (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    ansible-playbook playbook.yml -i inventory.ini --diff
    echo "✅ Configuration complete"
else
    echo "❌ Configuration cancelled"
fi

cd ..

echo "🎉 Deployment completed successfully!"
echo "📊 Access your services:"
echo "   Web Application: http://${WEB_IP}"
echo "   Grafana: http://${MONITORING_IP}:3000"
echo "   Prometheus: http://${MONITORING_IP}:9090"
