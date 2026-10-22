# Project Status

The homelab is powered off. This is a learning project, not an operating production platform.

## Source changes completed

- Validation-only GitHub and GitLab pipeline definitions.
- Removed unsupported performance/uptime metrics and placeholder success jobs.
- Removed tracked credential/local-variable files, state/backup, and generated provider artifacts from the current branch.
- Expanded ignore rules while retaining the provider lockfile.
- Removed hard-coded VM guest passwords and expanded SSH public-key paths.
- Enabled SSH host-key checking without an inventory override.
- Replaced the Windows-specific provider mirror with direct installation.
- Removed unused authentication inputs; documented provider environment variables.
- Added best-effort IP outputs and VM IDs for all three resources.

## Still unverified or outstanding

- Exposed credential rotation and historical-copy remediation.
- Passing CI logs, fresh Terraform validation, and end-to-end deployment.
- External cloud-init snippet, template credentials, disk-size compatibility, and SSH access.
- Ansible role privileges, dependencies, and actual execution.
- Running Vault/monitoring services and a successful backup restore.
- Comprehensive review of supporting scripts and documentation.

Removing a password from source does not update existing guests. Record actual commands, versions, logs, and outcomes before claiming deployment success or measured improvements.
