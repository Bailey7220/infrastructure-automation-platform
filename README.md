# Proxmox Infrastructure Automation Lab

A personal infrastructure-as-code project using Terraform VM definitions and Ansible roles to practice repeatable Proxmox lab setup.

> Personal lab project; the hardware is currently powered off. Static validation and deployment status are documented in the [project status log](PROJECT_STATUS.md). A working end-to-end deployment is not currently verified.

[Terraform](terraform/) | [Ansible](ansible/) | [Pipeline guide](docs/PIPELINE.md) | [Security remediation](docs/SECURITY_REMEDIATION.md) | [Related homelab](https://github.com/Bailey7220/Systems_and_Security_Homelab)

## Project scope

- Terraform definitions for three Proxmox VMs.
- Ansible roles for common setup, a web workload, and monitoring.
- Static-validation GitHub and GitLab configurations.
- Documentation of dependencies, security corrections, and remaining tests.

```text
Terraform -> Proxmox VMs -> verified guest addresses -> local Ansible inventory
Ansible roles -> guest configuration -> connectivity and service checks
```

This is the intended workflow, not a verified automated pipeline. Inventory setup is manual.

## VM configuration

| VM | vCPU | RAM | Disk | Storage |
|---|---:|---:|---:|---|
| web-server-001 | 2 | 2 GB | 20 GB | sas-disk1 |
| monitoring-001 | 2 | 4 GB | 30 GB | sas-disk1 |
| vault-001 | 2 | 2 GB | 10 GB | sas-disk1 |

Definitions clone template VM 300, use `vmbr0` and DHCP, and reference `local:snippets/cloud-init.yaml`. These dependencies must exist in the actual lab. Template disks must support the requested target sizes; disk shrinking is not implemented. The Vault-designated VM does not establish a working Vault service.

## Configuration and authentication

Copy `terraform/terraform.tfvars.example` to a local, ignored `terraform/terraform.tfvars` and set the actual node name and guest SSH public-key path.

The provider reads externally supplied environment variables:

- `PROXMOX_VE_ENDPOINT`: base HTTPS endpoint ending at port 8006, without `/api2/json`.
- `PROXMOX_VE_USERNAME` and `PROXMOX_VE_PASSWORD`, or `PROXMOX_VE_API_TOKEN`.

Keep credentials outside Git and TLS verification enabled. Some provider operations also need node SSH access; API authentication does not establish that access. See the [pinned provider documentation](https://github.com/bpg/terraform-provider-proxmox/blob/v0.57.1/docs/index.md).

## Validation

The CI definitions select Terraform 1.6.0 and Ansible Core 2.16.14. These are configuration choices, not claims of current support or passing tests.

```sh
terraform -chdir=terraform fmt -check
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
cd ansible
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Provider initialization requires registry access. Ansible module resolution currently needs dependency work; the Docker/Compose roles are not deployment-ready. The empty inventory is a template. No passing CI run is asserted, and syntax checks do not prove application health.

## Deployment blockers

- Rotate previously exposed credentials and assess historical copies. Current-branch removal does not erase history or invalidate credentials.
- Preserve private Terraform state for existing VMs; do not blindly apply with missing state.
- Verify the external cloud-init snippet, template credentials, guest-agent setup, storage, and network mapping.
- Migrate legacy Compose tasks and define compatible Ansible collection dependencies.
- Test readiness checks against loopback-bound monitoring ports. Supply Grafana credentials through an appropriate private runtime mechanism.
- Deployment and cleanup scripts are disabled pending replacement and testing; do not treat them as working entry points.
- Populate local inventory with verified guest addresses, verify SSH fingerprints through a trusted channel, and check role privileges before execution.

Removing source passwords does not change existing guests or Grafana accounts. Container image version pinning and full supporting-file review remain unfinished.

## Repository guide

| Path | Purpose |
|---|---|
| `terraform/` | VM definitions, variables, outputs, lockfile, sanitized input example |
| `ansible/` | Inventory template, playbook, configuration, roles |
| `.github/workflows/` | GitHub static checks |
| `.gitlab-ci.yml` | GitLab static checks |
| `docs/` | Architecture, pipeline, and security material |
| `scripts/` | Supporting scripts; deployment/cleanup currently disabled |
| `monitoring/`, `vault/` | Supporting material, not proof of deployed services |

## Evidence and limitations

Tracked local credentials, state/backup, and downloaded provider artifacts were removed from the current branch. Ignore rules reduce accidental re-addition; the provider lockfile remains tracked. The portable `.terraformrc` no longer requires the old Windows mirror, but repository-root CLI config is not automatically loaded on every platform.

No measured uptime, deployment/recovery time savings, compliance score, successful restore, or healthy live services are claimed. There is no root license file, so no open-source license is asserted.
