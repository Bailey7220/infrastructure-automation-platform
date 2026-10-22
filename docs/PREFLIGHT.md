# Local preflight checks

Run from the repository root using Bash:

```sh
bash scripts/preflight.sh "$HOME/.ssh/proxmox_lab.pub"
```

The positional argument must be the guest public-key file path you intend to configure through Terraform. This script checks only that the file is readable and nonempty; it does not parse Terraform inputs or confirm that the configured path matches. Never pass a password, token, or private-key value as this argument.

Before running, prepare the ignored local `terraform/terraform.tfvars` from the example and supply provider authentication through your private local environment. The script requires `PROXMOX_VE_ENDPOINT` and either `PROXMOX_VE_API_TOKEN` or both `PROXMOX_VE_USERNAME` and `PROXMOX_VE_PASSWORD`. Do not add lab credentials to CI or commit them to the repository.

## Scope

The script checks:

- Presence of Terraform, ansible-playbook, ansible-galaxy, and SSH commands on PATH, without executing them.
- Readable, nonempty Terraform source, lockfile, local tfvars, Ansible inventory, playbook, and requirements files.
- A readable, nonempty file at the explicitly supplied guest public-key path.
- Presence of authentication environment variables without displaying their values.

It performs local presence checks only. It does not invoke Terraform, Ansible, or SSH; contact Proxmox; install dependencies; write files; inspect state; or provision, configure, or destroy infrastructure. Shell tracing is disabled inside the script. Run it directly rather than sourcing it.

Exit status is 0 when all presence checks pass, 1 when any check fails, or 2 for incorrect usage. Relative public-key paths resolve from the caller's working directory; repository file checks resolve from the script location.

## Boundaries and remaining work

A pass does not establish supported tool versions, collection installation, HCL validity, active inventory hosts, public-key validity, endpoint validity, successful authentication, correct privileges, verified SSH fingerprints, or safe existing state. This minimal workflow expects `terraform/terraform.tfvars`; alternate Terraform input mechanisms are not detected.

Before any deployment, separately verify credential rotation, existing private state, template 300, storage, bridge, the external cloud-init snippet, template disk sizes, guest-agent availability, management addresses, guest package availability, and sudo access. Follow the README and security-remediation guide. Review a Terraform plan before approving any apply. Deployment and cleanup scripts remain disabled.

This script has not been executed against the lab. Its presence is not test evidence or deployment authorization.
