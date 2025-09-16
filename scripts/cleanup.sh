#!/bin/bash
# Infrastructure cleanup script

set -e

echo "🧹 Infrastructure Cleanup"
echo "========================"

echo "⚠️  This will destroy all infrastructure. Continue? (y/N)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    cd terraform
    terraform destroy -auto-approve
    echo "✅ Infrastructure destroyed"
else
    echo "❌ Cleanup cancelled"
fi
