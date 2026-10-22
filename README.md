# Proxmox Infrastructure Automation Lab

A personal infrastructure-as-code project using Terraform VM definitions and Ansible roles to practice repeatable Proxmox lab setup.

> The hardware is currently powered off. The repository owner reported that both GitHub static-check jobs passed on October 22, 2026, following the Terraform 1.6.1 patch update. Run evidence has not been independently recorded here; a fresh end-to-end deployment remains unverified.

[Status](PROJECT_STATUS.md) | [Terraform](terraform/) | [Ansible](ansible/) | [Pipeline guide](docs/PIPELINE.md) | [Security remediation](docs/SECURITY_REMEDIATION.md) | [Homelab](https://github.com/Bailey7220/Systems_and_Security_Homelab)

## Intended workflow

```text
Terraform -> Proxmox VMs -> verified addresses -> local Ansible inventory
Common setup -> Compose v2 workloads -> local HTTP readiness checks
```

Inventory setup is manual. This is a learning project, not a verified production deployment pipeline.

## What is implemented in source

- Three Proxmox VM definitions, with guest SSH public-key configuration.
- Common, webserver, and monitoring Ansible roles using fully qualified modules.
- Compose v2 application tasks; the common role checks for Compose 2.18 or newer.
- Explicit community.docker collection requirement and CI installation.
- Monitoring secret input passed to remote Compose under `no_log`.
- Monitoring HTTP readiness checks against guest loopback, with explicit retries.
- Static-only GitHub and GitLab checks; no CI apply, destroy, or Ansible deployment.

Source implementation and passing static checks do not prove these roles have executed successfully on guests.

## VM definitions

| VM | vCPU | RAM | Disk | Storage |
|---|---:|---:|---:|---|
| web-server-001 | 2 | 2 GB | 20 GB | sas-disk1 |
| monitoring-001 | 2 | 4 GB | 30 GB | sas-disk1 |
| vault-001 | 2 | 2 GB | 10 GB | sas-disk1 |

Definitions clone template VM 300, use `vmbr0` and DHCP, and reference `local:snippets/cloud-init.yaml`. Verify these dependencies and template disk compatibility before planning. Disk shrinking is not implemented. The Vault-designated VM does not establish a working Vault service.

## Local inputs and authentication

Copy `terraform/terraform.tfvars.example` to an ignored local `terraform/terraform.tfvars`. Set the actual node name and guest public-key path.

The provider uses externally supplied `PROXMOX_VE_ENDPOINT` plus `PROXMOX_VE_USERNAME`/`PROXMOX_VE_PASSWORD` or `PROXMOX_VE_API_TOKEN`. The endpoint is the base HTTPS URL on port 8006 without `/api2/json`. Keep TLS verification enabled. Some operations also require separately configured node SSH access.

[Authentication reference for the pinned provider](https://github.com/bpg/terraform-provider-proxmox/blob/v0.57.1/docs/index.md)

## Static validation

The workflows select Terraform 1.6.1, Ansible Core 2.16.14, and community.docker 3.13.3. These are compatibility pins, not a claim of a currently supported toolchain. Plan a supported-toolchain upgrade separately.

On October 22, 2026, the repository owner reported both GitHub jobs passing after commit `e8652e7a51960ce972bc01026a3ef27475c33611` changed the Terraform CLI pins from 1.6.0 to 1.6.1. This addressed the reported provider-installation failure, `openpgp: key expired`, without changing the Proxmox provider version or lockfile. The run URL and logs have not been independently recorded here. GitLab results and lab deployment remain unverified. See the [pipeline guide](docs/PIPELINE.md) for scope and evidence requirements.

From the repository root, with Terraform and the selected Ansible Core installed:

```sh
terraform -chdir=terraform fmt -check
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Registry and collection installation require network access. The inventory contains no active hosts. Syntax checks do not establish working privileges, guest package availability, service health, or deployment success. Inspect job logs for the exact commit before extending a passing-CI claim to later changes.

## Runtime prerequisites and limitations

- Rotate exposed credentials and assess historical copies. Removing tracked files does not invalidate credentials or erase Git history.
- Preserve private Terraform state needed for existing VMs; do not blindly apply with missing state.
- Inspect the external cloud-init snippet and template credentials. Removing source passwords does not update existing guests.
- Verify guest package availability: defaults request `docker.io` and `docker-compose-v2`. The common role checks Compose version; availability on the intended guest release is not verified.
- Verify SSH fingerprints, inventory addresses, sudo, storage, networking, and guest-agent setup before execution.
- Supply `grafana_admin_password` through an encrypted, untracked vars file. The monitoring role requires at least 16 characters and passes the value to remote Compose without logging it. This does not prove existing Grafana credentials were rotated.
- Published monitoring ports bind to guest loopback. External access needs a deliberately configured secure path; local HTTP readiness is not proof of scraping, dashboards, or network isolation.
- Deployment and cleanup scripts remain disabled until replacement workflows are reviewed and tested.
- Container images still need explicit version selection and testing. Backups, restores, repeat execution, and fresh deployment remain unverified.

## Repository guide

`terraform/` contains provisioning definitions; `ansible/` contains configuration roles and requirements. Workflow files define static checks. `docs/`, `scripts/`, `monitoring/`, and `vault/` contain supporting material; remaining and inactive material has not been comprehensively reviewed.

Tracked local credentials, state/backup, and generated providers were removed from the current branch; the provider lockfile remains. Ignore rules do not remove historical copies. The portable `.terraformrc` no longer requires the old Windows mirror, but repository-root CLI configuration is not automatically loaded on every platform.

No measured uptime, time savings, compliance score, working Vault service, or successful restore is claimed. No open-source license is asserted without a root license file.
