# Infrastructure Automation Platform

A comprehensive Terraform-based infrastructure automation solution for Proxmox VE homelab environments. This project provisions and manages virtual machines with optimized storage allocation, placing OS disks on high-performance SAS LVM-thin pools while maintaining cloud-init configuration on local SSD storage.

## 🏗️ Architecture Overview

This platform creates three core virtual machines:
- **Web Server** (web-server-001): 2 vCPU, 2GB RAM, 20GB SSD on sas-disk1
- **Monitoring Server** (monitoring-001): 2 vCPU, 4GB RAM, 30GB SSD on sas-disk1  
- **Vault Server** (vault-001): 2 vCPU, 2GB RAM, 10GB SSD on sas-disk2

All VMs are provisioned from an Ubuntu 22.04 template (VMID 300) with cloud-init for automated configuration.

## 📂 Repository Structure

infrastructure-automation-platform/
├── terraform/
│ ├── main.tf # VM resource definitions
│ ├── variables.tf # Variable declarations
│ ├── terraform.tfvars.example # Example configuration values
│ ├── outputs.tf # Output definitions for IP addresses
│ └── snippets/
│ └── cloud-init.yaml # Cloud-init user-data configuration
├── .gitignore # Git ignore patterns
├── README.md # This documentation
└── LICENSE # Project license

### File Descriptions

- **main.tf**: Contains all VM resource definitions using the `bpg/proxmox` provider v0.57.1
- **variables.tf**: Declares input variables for Proxmox connection, node configuration, and SSH keys
- **terraform.tfvars.example**: Template file showing required variable values (copy to terraform.tfvars)
- **outputs.tf**: Defines outputs for VM IP addresses and IDs for external reference
- **snippets/cloud-init.yaml**: Cloud-init configuration for user accounts, SSH keys, and package installation

## 🚀 Quick Start

### Prerequisites

1. **Proxmox VE 6.4+ or 7.x** with API access enabled
2. **Terraform 1.0+** installed on your workstation
3. **Ubuntu 22.04 LTS template** (VMID 300) configured in Proxmox
4. **LVM-thin storage pools** named `sas-disk1` and `sas-disk2`
5. **SSH key pair** for VM access
6. **Git** for version control

### Initial Setup

1. **Clone the repository**:
git clone https://github.com/Bailey7220/infrastructure-automation-platform.git
cd infrastructure-automation-platform/terraform

2. **Create your variables file**:
cp terraform.tfvars.example terraform.tfvars

3. **Configure your environment** by editing `terraform.tfvars`:
proxmox_url = "https://192.168.14.100:8006"
proxmox_user = "root@pam"
proxmox_password = "your-secure-password"
proxmox_node = "proxmox"
ssh_public_key = "/c/Users/Owner/.ssh/id_rsa.pub"

4. **Prepare the Ubuntu template** (CRITICAL STEP):
SSH to your Proxmox host
ssh root@192.168.14.100

Move template OS disk to SAS pool
qm move_disk 300 scsi0 sas-disk1

Verify the move was successful
qm config 300 | grep scsi0

Expected output: scsi0: sas-disk1:vm-300-disk-0,size=30G

5. **Initialize Terraform**:
terraform init


### Deployment

1. **Review the execution plan**:
terraform plan -out=tfplan.out

2. **Deploy the infrastructure**:
terraform apply tfplan.out


3. **Verify deployment**:
Check VM status
terraform output

Verify in Proxmox
ssh root@proxmox "qm list"

## 🔧 Detailed Configuration

### Provider Configuration
terraform {
required_providers {
proxmox = {
source = "bpg/proxmox"
version = "~>0.57.1"
}
}
}

provider "proxmox" {
pm_api_url = var.proxmox_url
pm_user = var.proxmox_user
pm_password = var.proxmox_password
pm_tls_insecure = true
}

### Variable Definitions

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `proxmox_url` | string | - | Proxmox API URL (https://ip:8006) |
| `proxmox_user` | string | - | Proxmox username (root@pam) |
| `proxmox_password` | string | - | Proxmox password (sensitive) |
| `proxmox_node` | string | "proxmox" | Target Proxmox node name |
| `ssh_public_key` | string | "~/.ssh/id_rsa.pub" | Path to SSH public key |

### VM Resource Template

Each VM follows this standardized configuration pattern:

resource "proxmox_virtual_environment_vm" "web_server" {
name = "web-server-001"
description = "Managed by Terraform"
node_name = var.proxmox_node

Clone from Ubuntu template
clone {
vm_id = 300
full = true
}

CPU configuration
cpu {
cores = 2
type = "host"
}

Memory allocation
memory {
dedicated = 2048
}

Primary OS disk on SAS storage
disk {
datastore_id = "sas-disk1"
interface = "scsi0"
size = 20
file_format = "raw"
cache = "writeback"
iothread = true
discard = "on"
}

Cloud-init configuration
initialization {
user_data_file_id = "local:snippets/cloud-init.yaml"
upgrade = true

ip_config {
  ipv4 {
    address = "dhcp"
  }
}

user_account {
  username = "vagrant"
  password = "vagrant"
  keys     = [file(var.ssh_public_key)]
}
}

Network configuration
network_device {
bridge = "vmbr0"
model = "virtio"
}

QEMU guest agent
agent {
enabled = true
type = "virtio"
timeout = "15m"
trim = false
}

tags = ["terraform", "web", "ubuntu"]
}

### Storage Pool Distribution

| VM | Pool | Size | Purpose |
|---|---|---|---|
| web-server-001 | sas-disk1 | 20GB | Web application server |
| monitoring-001 | sas-disk1 | 30GB | Prometheus/Grafana monitoring |
| vault-001 | sas-disk2 | 10GB | HashiCorp Vault secrets management |

## 🔐 Security Considerations

### SSH Key Management
- Generate dedicated SSH keys for this infrastructure: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/proxmox_lab`
- Use key-based authentication only; disable password authentication post-deployment
- Store private keys securely and never commit to version control

### Proxmox API Security
- Create a dedicated Proxmox user for Terraform with minimal required privileges
- Use strong, unique passwords for the Terraform API user
- Consider certificate-based authentication in production environments

### Network Security
- All VMs are placed on the default bridge (vmbr0) with DHCP
- Implement firewall rules at the Proxmox level for additional security
- Consider VLAN segmentation for production deployments

## 📋 Operational Procedures

### Daily Operations

**Check VM Status**:
terraform refresh
terraform output

**Update VM Configuration**:
1. Modify the appropriate resource in `main.tf`
2. Plan and apply changes:

terraform plan -out=update.tfplan
terraform apply update.tfplan

**Scale Resources**:
Example: Increase web server memory
Edit main.tf, change memory.dedicated = 4096
terraform plan -target=proxmox_virtual_environment_vm.web_server
terraform apply -target=proxmox_virtual_environment_vm.web_server

### Backup Procedures

**Template Backup**:
Create template snapshot
ssh root@proxmox "qm snapshot 300 pre-terraform-$(date +%Y%m%d)"

Backup template to external storage
ssh root@proxmox "vzdump 300 --storage backup-location"

**VM Backups**:
Automated backup of all managed VMs
for vm in $(terraform output -json | jq -r '.[] | select(.sensitive == false) | .value' | grep -E '^[0-9]+$'); do
ssh root@proxmox "vzdump $vm --storage backup-location"
done

### Disaster Recovery

**Complete Infrastructure Recreation**:
1. Restore Ubuntu template from backup
2. Recreate storage pools if necessary
3. Run terraform apply to rebuild all VMs
4. Restore application data from backups

**Individual VM Recovery**:
Destroy specific VM
terraform destroy -target=proxmox_virtual_environment_vm.web_server

Recreate VM
terraform apply -target=proxmox_virtual_environment_vm.web_server

## 🛠️ Troubleshooting

### Common Issues

**Problem: Terraform init fails with DNS errors**
Solution: Use local provider mirror
mkdir -p .terraform/plugins/windows_amd64

Download provider manually and place in plugins directory
Create ~/.terraformrc with filesystem mirror configuration

**Problem: VMs created on wrong storage pool**
Verify template location
ssh root@proxmox "qm config 300 | grep scsi0"

If template is on local-lvm, move it:
ssh root@proxmox "qm move_disk 300 scsi0 sas-disk1"

**Problem: Cloud-init not working**
Verify cloud-init file exists
ssh root@proxmox "ls -la /var/lib/vz/snippets/cloud-init.yaml"

Check VM cloud-init status
ssh vagrant@vm-ip "sudo cloud-init status --long"

**Problem: VMs can't reach internet**
Check Proxmox bridge configuration
ssh root@proxmox "ip addr show vmbr0"

Verify VM network configuration
ssh vagrant@vm-ip "ip route show"

### Debug Commands

**Terraform Debugging**:
Enable verbose logging
export TF_LOG=DEBUG
terraform plan

Show state details
terraform show

Verify provider configuration
terraform providers

**Proxmox Debugging**:
Check VM configuration
qm config <vmid>

Monitor VM console
qm monitor <vmid>

Check storage status
pvesm status

Verify LVM thin pool usage
lvs -o +data_percent

## 📈 Monitoring and Maintenance

### Storage Monitoring
Check thin pool usage (alert at 75%)
ssh root@proxmox "lvs -o lv_name,data_percent sas-disk1 sas-disk2"

Monitor VM disk usage
for vm in web-server-001 monitoring-001 vault-001; do
ssh vagrant@$vm "df -h /"
done

### Performance Monitoring
Check VM CPU/Memory usage
ssh root@proxmox "qm list"

Monitor network performance
ssh vagrant@vm-ip "iftop -t -s 10"

### Automated Health Checks
Create a monitoring script to verify infrastructure health:

#!/bin/bash

health-check.sh
echo "=== Infrastructure Health Check ==="
echo "Date: $(date)"

Check Terraform state
cd /path/to/terraform
terraform refresh > /dev/null 2>&1
if [ $? -eq 0 ]; then
echo "✅ Terraform state: OK"
else
echo "❌ Terraform state: ERROR"
fi

Check VM connectivity
for vm in $(terraform output -json | jq -r 'to_entries[] | select(.key | endswith("_ip")) | .value.value'); do
if ping -c 1 $vm > /dev/null 2>&1; then
echo "✅ VM $vm: Reachable"
else
echo "❌ VM $vm: Unreachable"
fi
done

Check storage usage
ssh root@proxmox "lvs -o lv_name,data_percent --noheadings sas-disk1 sas-disk2" | while read lv percent; do
if [ ${percent%.*} -gt 75 ]; then
echo "⚠️ Storage $lv: ${percent}% used (WARNING)"
else
echo "✅ Storage $lv: ${percent}% used"
fi
done

## 🔄 CI/CD Integration

### GitLab CI Pipeline Example
stages:

validate

plan

deploy

variables:
TF_ROOT: terraform/
TF_VAR_FILE: terraform.tfvars

terraform-validate:
stage: validate
script:
- cd $TF_ROOT
- terraform init
- terraform validate

terraform-plan:
stage: plan
script:
- cd $TF_ROOT
- terraform init
- terraform plan -var-file=$TF_VAR_FILE -out=tfplan
artifacts:
paths:
- $TF_ROOT/tfplan
expire_in: 1 hour

terraform-apply:
stage: deploy
script:
- cd $TF_ROOT
- terraform init
- terraform apply tfplan
when: manual
only:
- main

## 🤝 Contributing

### Development Workflow

1. **Create feature branch**:
git checkout -b feature/new-vm-type

2. **Make changes and test**:
terraform fmt
terraform validate
terraform plan

3. **Commit and push**:
git add .
git commit -m "Add new VM type: database server"
git push origin feature/new-vm-type


4. **Create pull request** via GitHub/GitLab UI

5. **After merge, cleanup**:
git checkout main
git pull origin main
git branch -d feature/new-vm-type

### Coding Standards

- Use consistent resource naming: `{service}_{environment}_{instance}`
- Add comprehensive tags to all resources
- Document all variables with descriptions
- Use sensitive = true for passwords and secrets
- Follow Terraform best practices for state management

## 📚 Additional Resources

### Official Documentation
- [Terraform Documentation](https://www.terraform.io/docs)
- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [BPG Proxmox Provider](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

### Related Projects
- [Proxmox Ansible Collection](https://github.com/community-general/community.general)
- [Terraform Proxmox Examples](https://github.com/Telmate/terraform-provider-proxmox/tree/master/examples)

### Community Resources
- [r/Proxmox](https://reddit.com/r/Proxmox)
- [Proxmox Community Forum](https://forum.proxmox.com/)
- [Terraform Community](https://discuss.hashicorp.com/c/terraform-core/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Last Updated**: December 2025  
**Terraform Version**: 1.6+  
**Proxmox Version**: 7.4+  
**Provider Version**: bpg/proxmox ~>0.57.1
