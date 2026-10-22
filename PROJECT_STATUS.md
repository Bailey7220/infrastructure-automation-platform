# Project Status

The homelab is powered off. This is a learning project, not an operating production platform. Source changes and passing static checks are not deployment evidence.

## Reported static validation

On October 22, 2026, the repository owner reported that both Terraform and Ansible jobs passed in GitHub Actions after commit `e8652e7a51960ce972bc01026a3ef27475c33611` updated the Terraform CLI pins from 1.6.0 to 1.6.1. The preceding provider installation failed with `openpgp: key expired`; the provider version and lockfile were unchanged by the fix.

This is an owner-reported result. A run URL, run ID, and job logs have not been independently recorded here. It does not establish passing GitLab checks, successful later commits, or a working deployment. See [the pipeline guide](docs/PIPELINE.md) for check boundaries and evidence requirements.

## Source corrections present

- Static-only GitHub and GitLab pipeline definitions; collection installation is now explicit.
- Terraform CLI pinned to 1.6.1 in both CI configurations.
- SSH arguments require host-key checking; deploy and cleanup scripts remain blocked.
- Monitoring template requires a runtime Grafana secret, binds published ports to loopback, and does not enable the Prometheus lifecycle API.
- Added community.docker 3.13.3 as a compatibility bridge for the existing Core 2.16.14 pin, not a supported-toolchain claim.
- Active web and monitoring tasks use fully qualified Compose v2 modules; common tasks no longer install pip Docker/Compose v1 packages or rely on newly granted Docker group access.
- Common role checks Compose version and uses explicit privilege escalation for Docker operations.
- Monitoring passes an explicit secret to remote Compose under no_log; endpoint checks use guest loopback with explicit retry conditions.
- Pipeline documentation describes static checks only and records the owner-reported GitHub result.
- Previously documented current-branch credential/state/artifact cleanup does not establish historical remediation.

## Still outstanding

- Rotate/revoke exposed credentials, verify existing Grafana accounts, and assess historical copies.
- Record the GitHub run URL, commit SHA, and job conclusions; verify GitLab results separately and check subsequent commits independently.
- Upgrade to a supported toolchain and test exact Docker/Compose/image versions.
- Verify guest package availability, sudo, templates, and actual role execution. The reported static-check pass does not cover these runtime prerequisites.
- Check external cloud-init/template credentials, storage, disks, private Terraform state, SSH enrollment, and management addresses.
- Validate monitoring scrapes/dashboards, network isolation, backup restores, repeat execution, and fresh deployment.
- Review remaining supporting files and inactive role material.
- Replace and validate scripts before re-enabling infrastructure operations.

No deployment, credential rotation, history remediation, or successful restore is claimed. See [the pipeline guide](docs/PIPELINE.md) and [security remediation](docs/SECURITY_REMEDIATION.md).
