# Static Validation Pipeline

## Scope

GitHub and GitLab define static checks only. Neither provisions infrastructure nor deploys Ansible workloads.

## Reported validation result

On October 22, 2026, the repository owner reported that both Terraform and Ansible jobs passed in GitHub Actions after commit `e8652e7a51960ce972bc01026a3ef27475c33611` updated the Terraform CLI pin from 1.6.0 to 1.6.1. This is an owner-reported result; a run URL, run ID, and job logs have not been independently recorded here. It does not establish a passing GitLab pipeline or successful lab deployment.

The preceding failure occurred during provider installation: `bpg/proxmox` v0.57.1 could not be installed because signature checking returned `openpgp: key expired`. The patch changed only the Terraform CLI pins in the two CI files; the provider version and lockfile were left unchanged.

| Step | Purpose | Boundary |
|---|---|---|
| Terraform formatting | Check source formatting | Not runtime correctness |
| Terraform initialization | Install required providers without backend initialization | Not lab authentication or deployment |
| Terraform validation | Check configuration against installed providers | Not a successful plan/apply |
| Collection installation | Install `ansible/requirements.yml` | Not guest dependency installation |
| Ansible syntax check | Resolve tasks and check playbook syntax | Not role execution or service health |

The configuration selects Terraform 1.6.1, Ansible Core 2.16.14, and community.docker 3.13.3. These compatibility pins are not a supported-toolchain claim. A supported-toolchain upgrade remains separate work.

## Compose migration status

Active web and monitoring roles use `community.docker.docker_compose_v2`. The common role checks for Compose 2.18 or newer. Collection installation is explicit in CI; the owner-reported GitHub pass covers that static-check workflow, not execution on guests.

Guest package availability, actual role execution, and end-to-end behavior still require testing. Monitoring readiness checks target guest loopback with explicit retries; their presence is not evidence of a successful deployment.

## What CI does not do

No Terraform apply/destroy, Ansible deployment, dynamic inventory generation, comprehensive secret scan, service health verification, monitoring setup, backup testing, or performance measurement is claimed. Deployment and cleanup scripts remain disabled pending replacement and testing.

## Secrets and runtime

Do not supply lab passwords or SSH private keys merely to make static checks pass. Deliberate local deployment uses the provider-supported `PROXMOX_VE_*` variables described in the README. The Grafana role requires a private runtime secret. Existing credentials and historical exposure require separate remediation.

## Record reproducible evidence

1. Open the repository Actions tab and select Static Configuration Checks for the exact commit under review.
2. Inspect Terraform and Ansible job logs, including dependency installation.
3. Record the run URL, commit SHA, and job conclusions without copying secrets into the repository.
4. Treat subsequent commits as requiring their own checks; a previous passing run is not evidence for later changes.

For GitLab, inspect and record equivalent job logs separately. No successful deployment is asserted by this guide.
