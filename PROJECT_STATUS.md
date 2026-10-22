# Project Status

The homelab is powered off. This is a learning project, not an operating production platform. Source changes are not execution evidence.

## Source corrections present

- Static-only GitHub and GitLab pipeline definitions; collection installation is now explicit.
- SSH arguments require host-key checking; deploy and cleanup scripts remain blocked.
- Monitoring template requires a runtime Grafana secret, binds published ports to loopback, and does not enable the Prometheus lifecycle API.
- Added community.docker 3.13.3 as a compatibility bridge for the existing Core 2.16.14 pin, not a supported-toolchain claim.
- Active web and monitoring tasks use fully qualified Compose v2 modules; common tasks no longer install pip Docker/Compose v1 packages or rely on newly granted Docker group access.
- Common role checks Compose version and uses explicit privilege escalation for Docker operations.
- Monitoring passes an explicit secret to remote Compose under no_log; endpoint checks use guest loopback with explicit retry conditions.
- Pipeline documentation now describes static checks only.
- Previously documented current-branch credential/state/artifact cleanup does not establish historical remediation.

## Still outstanding

- Rotate/revoke exposed credentials, verify existing Grafana accounts, and assess historical copies.
- Upgrade to a supported toolchain and test exact Docker/Compose/image versions.
- Verify collection installation, passing CI, guest package availability, sudo, templates, and execution.
- Check external cloud-init/template credentials, storage, disks, private Terraform state, SSH enrollment, and management addresses.
- Validate monitoring scrapes/dashboards, network isolation, backup restores, repeat execution, and fresh deployment.
- Review remaining supporting files and inactive role material.
- Replace and validate scripts before re-enabling infrastructure operations.

No deployment, CI pass, credential rotation, history remediation, or successful restore is claimed. See docs/PIPELINE.md and docs/SECURITY_REMEDIATION.md.
