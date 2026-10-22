# Proxmox Infrastructure Automation Lab

A personal infrastructure-as-code project with Terraform definitions for Proxmox virtual machines and Ansible configuration roles.

> Status: the homelab is powered off. Configuration exists, but a fresh end-to-end deployment has not been verified. This is not an active production platform.

## Purpose

Practice repeatable VM definitions, configuration management, and basic automation validation without claiming production reliability or measured business impact.

## What is in the repository

| Component | Present | Verification boundary |
|---|---|---|
| Terraform | Three VM resources: web, monitoring, and Vault-designated host | Resource definitions do not establish that applications are installed or healthy |
| Ansible | Playbook invoking common, webserver, and monitoring roles | Successful execution needs revalidation |
| CI | Terraform formatting/validation and Ansible syntax checks | Static checks do not prove deployment or service health |
| Additional folders | Documentation, scripts, monitoring, and Vault-related material | Not independently validated as a working platform |

## Intended workflow

```text
Terraform definitions -> Proxmox VM provisioning
Ansible inventory + roles -> guest configuration
Verification -> console, network, and service checks
```

This illustrates the intended workflow, not a verified automated handoff between Terraform and Ansible.

## VM definitions

| Resource | vCPU | RAM | Disk | Storage |
|---|---:|---:|---:|---|
| web-server-001 | 2 | 2 GB | 20 GB | sas-disk1 |
| monitoring-001 | 2 | 4 GB | 30 GB | sas-disk1 |
| vault-001 | 2 | 2 GB | 10 GB | sas-disk1 |

Current definitions clone template VM 300, attach to `vmbr0`, request DHCP, and reference `local:snippets/cloud-init.yaml`. Those are environment-specific assumptions, not portable defaults. The snippet is external to this repository and must be inspected before reuse. Template disk sizes and target storage must also be checked before planning.

## Repository guide

- `terraform/`: VM definitions, inputs, outputs, and provider lockfile.
- `ansible/`: inventory, playbook, configuration, and roles.
- `.github/workflows/`: GitHub static validation.
- `.gitlab-ci.yml`: GitLab static validation alternative.
- `PROJECT_STATUS.md`: implementation and verification status.
- `docs/`, `scripts/`, `monitoring/`, `vault/`: supporting project material.

## Safe local checks

From the repository root:

```sh
terraform -chdir=terraform fmt -check
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
cd ansible
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Initialization downloads providers and requires registry access. These checks can fail and must be reviewed; no passing run is claimed by the existence of these commands.

## Before attempting deployment

1. Rotate previously exposed credentials before reconnecting the lab. Deleting the current file does not remove Git history.
2. Complete the tracked-state/generated-file cleanup and review historical copies for secrets.
3. Review Terraform guest credentials and the external cloud-init snippet; do not reuse demo passwords or assume password login is disabled.
4. Check the provider's authentication requirements for the pinned version. The empty provider block requires an appropriate external configuration; declaring Terraform variables alone does not authenticate it.
5. Review template, storage, network, inventory, SSH keys, and permissions against the actual lab.
6. Establish console access and a recovery path before any network change.
7. Review a Terraform plan locally before authorizing changes. CI does not apply or destroy infrastructure.

The variable example is a sanitized description of inputs, not a complete working deployment configuration.

## Security and limitations

- Never commit credentials, private keys, Terraform state, saved plans, or downloaded provider files.
- Ignore rules do not untrack existing files or erase history.
- Terraform's `sensitive` setting does not remove a secret from tracked files.
- No uptime, deployment-time improvement, recovery-time improvement, or compliance score is claimed.
- No tested backup/restore or working Vault deployment is claimed.
- No license is asserted here; the repository currently has no root license file.

[Related homelab](https://github.com/Bailey7220/Systems_and_Security_Homelab)
