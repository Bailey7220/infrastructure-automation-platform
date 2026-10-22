# Project Status

## Current environment

The associated homelab is powered off. This repository is an infrastructure automation learning project, not an operating production service.

| Area | Evidence present | Status |
|---|---|---|
| Terraform | VM definitions, variables, outputs, provider lockfile | Fresh validation and deployment required |
| Ansible | Playbook and role directories | Syntax and execution need verification |
| CI | Static validation definitions | No successful run claimed until logs confirm it |
| Vault | VM definition and supporting directory | Service deployment not verified |
| Monitoring | Roles and supporting files | Running services and alerting not verified |
| Backup and recovery | Earlier documentation | Successful restore not verified |

## Cleanup progress

- Plaintext local credential file removed from the current branch.
- Credential rotation and history remediation remain necessary.
- Documentation no longer asserts unsupported performance or uptime metrics.
- Placeholder deployment/test success jobs replaced with static validation.
- Ignore rules expanded; previously tracked files still require explicit removal.
- Demo guest credentials and external cloud-init configuration still require review before deployment.

## Evidence needed later

Record tool versions, actual commands, validation logs, deployment outcomes, and sanitized screenshots. Only publish measured improvements when the baseline, method, and results are documented.
