# Project Status

The homelab is powered off. This is a learning project, not an operating production platform. Source edits are not evidence of successful execution.

## Existing source work

- Static-validation GitHub and GitLab pipeline definitions are present. Passing runs are not verified here.
- Current-branch local credential/state/provider-artifact cleanup was previously documented; historical remediation remains unverified.
- Terraform authentication uses environment variables; address outputs are best-effort and may be null.

## Security corrections in this batch

- Global SSH arguments now require host-key checking. Trusted host-key enrollment and actual connections remain untested.
- Deployment and cleanup scripts now exit without executing infrastructure commands while replacement workflows are pending.
- Removed the fixed Grafana password from the monitoring template. Compose requires GRAFANA_ADMIN_PASSWORD at runtime.
- Monitoring port mappings now bind to host loopback; Prometheus lifecycle API enablement was removed.
- These are source corrections only. Existing services, accounts, secrets, and historical copies were not changed.

## Still outstanding

- Rotate or revoke previously exposed credentials and assess historical copies.
- Verify existing Grafana administrator credentials separately; template edits do not prove rotation.
- Migrate Docker/Compose modules and define compatible Ansible collection dependencies.
- Replace inaccurate pipeline documentation and review remaining supporting files.
- Run static checks and record actual CI results.
- Verify external cloud-init/template credentials, storage, disks, SSH access, and private Terraform state.
- Replace and test deployment/cleanup workflows before re-enabling scripts.
- Test monitoring readiness checks against the new loopback bindings.
- Verify deployed services, backup restores, and end-to-end behavior before claiming success.
- Select and test explicit container image versions; latest tags remain for now.

See docs/SECURITY_REMEDIATION.md for operating boundaries.
