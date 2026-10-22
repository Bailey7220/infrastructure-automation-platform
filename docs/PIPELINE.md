# Static Validation Pipeline

## Scope

GitHub and GitLab define static checks only. Neither provisions infrastructure nor deploys Ansible workloads. Passing runs have not been verified here.

| Step | Purpose | Boundary |
|---|---|---|
| Terraform formatting | Check source formatting | Not runtime correctness |
| Terraform initialization | Install required providers without backend initialization | Not lab authentication or deployment |
| Terraform validation | Check configuration against installed providers | Not a successful plan/apply |
| Collection installation | Install `ansible/requirements.yml` | Not guest dependency installation |
| Ansible syntax check | Resolve tasks and check playbook syntax | Not role execution or service health |

The configuration selects Terraform 1.6.0, Ansible Core 2.16.14, and community.docker 3.13.3. These compatibility pins are not a supported-toolchain or passing-test claim.

## Compose migration status

Active web and monitoring roles now use `community.docker.docker_compose_v2`. The common role checks for Compose 2.18 or newer. Collection installation is explicit in CI. Earlier statements that these source changes were still pending are superseded by this document.

Guest package availability, collection installation success, actual execution, and end-to-end behavior still require testing. Monitoring readiness checks now target guest loopback with explicit retries; their presence is not evidence of a successful run.

## What CI does not do

No Terraform apply/destroy, Ansible deployment, dynamic inventory generation, comprehensive secret scan, service health verification, monitoring setup, backup testing, or performance measurement is claimed. Deployment and cleanup scripts remain disabled pending replacement and testing.

## Secrets and runtime

Do not supply lab passwords or SSH private keys merely to make static checks pass. Deliberate local deployment uses the provider-supported `PROXMOX_VE_*` variables described in the README. The Grafana role requires a private runtime secret. Existing credentials and historical exposure require separate remediation.

## Verify the actual result

1. Open the repository Actions tab and select Static Configuration Checks for the exact commit under review.
2. Inspect Terraform and Ansible job logs, including dependency installation.
3. Record commit, job conclusion, and any failures.
4. Fix failures instead of hiding them or publishing an unverified passing badge.

For GitLab, inspect equivalent job logs. No successful run or deployment is asserted by this guide.
