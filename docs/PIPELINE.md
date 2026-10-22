# Static Validation Pipeline

## Current scope

The GitHub workflow and GitLab configuration define static checks, not an infrastructure deployment pipeline. The lab is powered off. Passing job results have not been verified in this documentation.

| Check | Intended command | What it does not establish |
|---|---|---|
| Terraform formatting | `terraform fmt -check -no-color` | Correct runtime configuration |
| Terraform initialization | `terraform init -backend=false -input=false` | Authentication or access to the lab |
| Terraform validation | `terraform validate -no-color` | A successful plan/apply |
| Ansible syntax | `ansible-playbook --syntax-check -i inventory.ini playbook.yml` | Successful role execution or service health |

The current CI definitions select Terraform 1.6.0 and Ansible Core 2.16.14. Ansible collection dependencies and legacy Docker Compose modules still require remediation. Do not interpret a configured job as a passing job.

## Removed behavior

The earlier guide described security scans, automatic provisioning, dynamic inventory, application deployment, monitoring setup, tests, and cleanup as implemented pipeline stages. That description was inaccurate and is superseded by this document.

The current validation pipelines do not perform Terraform apply/destroy, run an Ansible deployment, configure monitoring, verify backups, or measure performance. Placeholder success messages are not test evidence. Deployment and cleanup scripts remain disabled pending replacement and testing.

## Credentials

Do not add lab passwords, API tokens, or SSH private keys merely to make static validation pass. Runtime authentication, when deployment is deliberately tested, uses the provider-supported `PROXMOX_VE_*` variables described in the README. The previous `PROXMOX_URL`, `PROXMOX_USER`, and `PROXMOX_PASSWORD` table is obsolete for the current configuration.

## How to verify results

1. Open the repository's Actions tab.
2. Select the Static Configuration Checks run for the exact commit being reviewed.
3. Inspect both Terraform and Ansible job logs.
4. Record the commit, job conclusions, and any failures.
5. Resolve failures rather than hiding them with `|| true` or publishing a passing badge without evidence.

For GitLab, inspect the equivalent job logs and commit. These steps describe verification; this document does not assert that it has been completed.

## Next runtime milestone

Complete module/dependency remediation, inspect the external template/snippet, and test a reviewed local deployment against the actual lab. Record real outcomes before adding deployment stages or claims of service readiness.
