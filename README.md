# Proxmox Infrastructure Automation Lab

A personal infrastructure-as-code project using Terraform VM definitions and Ansible configuration roles to practice repeatable Proxmox lab setup.

> The homelab is powered off. Source configuration is present, but a fresh end-to-end deployment and passing CI results have not been verified. This is not an active production platform.

[Status](PROJECT_STATUS.md) | [Terraform](terraform/) | [Ansible](ansible/) | [Related homelab](https://github.com/Bailey7220/Systems_and_Security_Homelab)

## Purpose and workflow

Practice VM resource definitions, role-based configuration management, and static validation:

```text
Terraform -> Proxmox VMs -> verified addresses -> local Ansible inventory
Ansible roles -> guest configuration -> actual connectivity/service checks
```

The inventory handoff is manual; this is not a verified end-to-end deployment pipeline.

## VM definitions

| VM | vCPU | RAM | Disk | Storage |
|---|---:|---:|---:|---|
| web-server-001 | 2 | 2 GB | 20 GB | sas-disk1 |
| monitoring-001 | 2 | 4 GB | 30 GB | sas-disk1 |
| vault-001 | 2 | 2 GB | 10 GB | sas-disk1 |

All definitions clone template VM 300, attach to `vmbr0`, request DHCP, and reference `local:snippets/cloud-init.yaml`. Verify these lab-specific dependencies before planning. Template disks must be compatible with the requested sizes; this project does not implement disk shrinking. A Vault-designated VM does not establish a working Vault service.

## Repository guide

- `terraform/`: VM definitions, inputs, outputs, lockfile, sanitized variable example.
- `ansible/`: inventory template, playbook, configuration, common/webserver/monitoring roles.
- `.github/workflows/` and `.gitlab-ci.yml`: static validation alternatives, not deployment automation.
- `PROJECT_STATUS.md`: completed source changes and verification boundaries.
- `docs/`, `scripts/`, `monitoring/`, `vault/`: supporting material not comprehensively revalidated.

## Inputs and authentication

Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` locally. Set the node name and public-key path; do not commit local values or secrets.

The empty provider block uses environment-variable authentication supported by the pinned `bpg/proxmox` version:

- `PROXMOX_VE_ENDPOINT`: base URL such as `https://proxmox.example.invalid:8006/`, without `/api2/json`.
- `PROXMOX_VE_USERNAME` and `PROXMOX_VE_PASSWORD`, or the `PROXMOX_VE_API_TOKEN` alternative, supplied outside Git.
- Keep TLS verification enabled and configure certificate trust.
- Operations requiring node SSH access need separate appropriate SSH configuration; API authentication alone does not establish it.

Unused `proxmox_url`, `proxmox_user`, and `proxmox_password` Terraform inputs were removed. See the [pinned provider authentication reference](https://github.com/bpg/terraform-provider-proxmox/blob/v0.57.1/docs/index.md).

## Static checks

The pipelines select Terraform 1.6.0 and Ansible Core 2.16.14 for reproducibility, not as a claim that they are current or tested successfully here.

From the repository root:

```sh
terraform -chdir=terraform fmt -check
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
cd ansible
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Initialization requires registry access. Syntax checks can reveal missing dependencies but do not prove role execution. The inventory intentionally has no active hosts. CI does not apply/destroy infrastructure or deploy Ansible changes.

## Before local deployment

1. Rotate the previously exposed credential and address historical copies. Current-branch deletion does not erase history.
2. Preserve private Terraform state needed to manage existing VMs. Do not blindly apply against previously managed infrastructure with missing state.
3. Verify provider permissions, template, storage, disk sizes, bridge, and guest-agent setup.
4. Inspect the external cloud-init snippet and template. Source demo passwords were removed, but inherited passwords and SSH login policy have not been verified.
5. Review the plan before authorizing changes; initialization edits can affect existing resources.
6. Verify actual guest addresses. Convenience IP outputs may be null and do not guarantee the correct management interface.
7. Populate local inventory and verify SSH fingerprints through a trusted channel. Choose the appropriate local SSH key or agent.
8. Check Ansible privileges/dependencies and record actual deployment and health-test outcomes.

## Cleanup and limitations

Tracked local variables, state/backup, and generated providers were removed from the current branch; the lockfile remains. Ignore rules reduce accidental re-addition, not historical exposure. The portable `.terraformrc` removes the old Windows mirror, but repository-root CLI configuration is not automatically loaded on every platform.

No measured uptime, time savings, compliance score, working Vault service, or successful restore is claimed. There is currently no root license file, so no open-source license is asserted here.
