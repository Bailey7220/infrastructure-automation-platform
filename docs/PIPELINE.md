# Static Validation Pipeline

## Scope and compatibility pins

GitHub and GitLab define static checks only. Neither provisions infrastructure nor deploys Ansible workloads. Terraform 1.6.1, Ansible Core 2.16.14, and community.docker 3.13.3 are compatibility pins, not a supported-toolchain claim.

| Workflow | Coverage | Boundary |
|---|---|---|
| GitHub: Static Configuration Checks | Terraform formatting, provider initialization without backend initialization, configuration validation, collection installation, Ansible syntax, and `scripts/*.sh` syntax/carriage-return checks | No infrastructure deployment or shell-script behavior verification in the syntax job |
| GitHub: Preflight Regression Tests | Six Python unittest cases using temporary dummy files, fake authentication values, and command stubs | Tests preflight presence-check behavior, not real credentials, public keys, or lab readiness |
| GitLab static pipeline | Terraform formatting/init/validation and Ansible collection installation/syntax | Does not include the added GitHub shell or preflight regression jobs; passing GitLab results are not recorded |

The regression tests check usage errors, token and password input paths, six missing prerequisites together, incomplete authentication inputs, and an empty key file. Each invocation checks that dummy authentication values are absent from output and that stubbed infrastructure commands were not invoked. This is not a general secret-leak or network-isolation audit.

## Reported results and fixes

On October 22, 2026, the owner reported GitHub Terraform and Ansible checks passing after the CLI update from 1.6.0 to 1.6.1 addressed `openpgp: key expired` during installation of `bpg/proxmox` 0.57.1.

The owner then supplied successful local Terraform and Ansible static-check output from Ubuntu WSL. Commit `78808fa` added a Linux provider checksum without changing the provider version. Commit `8ef54bc` added shell LF checkout rules, and `a5b9c33` added shell checks. The owner reported the preflight regression workflow passing after `212b8a8`.

Exact Actions run URLs and complete job logs have not been recorded or independently reviewed here. These reports do not prove later commits pass. See [project status](../PROJECT_STATUS.md) for the evidence boundary.

## Local verification

Use a Linux checkout with trustworthy permissions and the intended tool versions. Ansible should load `ansible/ansible.cfg`; do not bypass its world-writable-directory protection.

From the repository root, run commands individually and stop on failure:

```sh
terraform -chdir=terraform fmt -check -no-color
terraform -chdir=terraform init -backend=false -input=false -lockfile=readonly
terraform -chdir=terraform validate -no-color
python3 -m unittest discover -s tests -p 'test_preflight.py' -v
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook --syntax-check -i inventory.ini playbook.yml
```

Network access is needed for dependency installation. For a new platform, use `terraform providers lock -platform=...` deliberately and review the resulting hashes; do not delete the lockfile, bypass verification, or upgrade providers to hide a checksum error.

## Runtime and evidence boundaries

Do not add lab passwords or SSH private keys to CI. Compose v2 tasks, guest-loopback readiness checks, and private Grafana inputs are source implementations, not successful runtime evidence. The inventory is deliberately inactive. Deployment and cleanup scripts remain disabled.

Record each tested commit's run URL, SHA, versions, job conclusions, and sanitized evidence. Check GitLab separately. No apply/destroy, role execution, monitoring health, credential rotation, backup restoration, or performance measurement is established by these checks.
