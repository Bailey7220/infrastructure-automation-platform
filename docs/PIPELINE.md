# Static configuration checks

GitHub Actions and GitLab define alternative static-validation pipelines. Neither provisions infrastructure, configures guests, scans secrets, verifies services, measures performance, or destroys resources.

## Actual checks

- Terraform 1.6.0: format check, initialization with backend disabled, and validation.
- Python 3.11 and Ansible Core 2.16.14: install the collection declared in ansible/requirements.yml and syntax-check playbook.yml with the placeholder inventory.

The pinned community.docker 3.13.3 declares Ansible >=2.11 and provides docker_compose_v2. This is a compatibility bridge for the existing Core pin, not a claim of current security support or a tested deployment stack. A supported-toolchain upgrade remains required before deployment. Registry/Galaxy access is required. No passing CI run is asserted by this document.

## Local static checks

From the repository root:

```sh
terraform -chdir=terraform fmt -check
terraform -chdir=terraform init -backend=false -input=false
terraform -chdir=terraform validate
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Use an isolated Python environment for Ansible Core. Syntax checking does not exercise package installation, templates, privileges, remote connections, secret handling, or Compose execution. Check mode is also incomplete: Compose and HTTP checks deliberately skip it because a fresh guest may not have rendered files or running services.

## Runtime prerequisites and boundaries

Roles use Docker CLI Compose v2, not pip-installed docker-compose v1 or the Python Docker SDK. Ubuntu package defaults are docker.io and docker-compose-v2; verify repository availability on the actual guest release and override docker_packages deliberately when needed. The common role checks for Compose >=2.18.0. This minimum is not a compatibility guarantee for every newer Docker/Compose combination. Test exact host versions before use.

Docker operations use explicit privilege escalation instead of relying on newly acquired Docker group membership. The SSH user needs an approved sudo configuration; supply become credentials privately when required.

Supply grafana_admin_password as a string of at least 16 characters in an encrypted, untracked Ansible vars file. The monitoring task explicitly passes it to the remote Compose process and suppresses task logging. Do not use a literal secret on the command line. Existing Grafana account rotation must be verified separately. Container environment variables are visible to privileged Docker administrators; this is not a complete secret-management design.

Monitoring checks run on the guest against loopback, matching the template port bindings. An HTTP 200 verifies only that endpoint, not scrape coverage, dashboard correctness, network isolation, backups, or full deployment health.

Terraform runtime authentication uses the provider's PROXMOX_VE_* variables documented in README.md. CI does not need Proxmox credentials. Deployment and cleanup scripts remain intentionally disabled.

## Still to verify

Collection installation, actual syntax-check results, supported tool versions, guest package availability, templates, network paths, existing state, credentials, image versions, repeat execution, and service behavior. Record outcomes only after running the checks.
