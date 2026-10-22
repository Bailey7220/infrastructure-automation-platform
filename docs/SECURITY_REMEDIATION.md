# Security remediation and verification boundaries

Repository edits do not rotate credentials, rewrite history, change running services, or prove deployment success. Rotate or revoke exposed credentials at their actual services and assess historical copies separately. Never publish replacement secrets or Terraform state.

## SSH

Verify fingerprints through a trusted console or authenticated channel before enrolling keys in the controller's known_hosts file. Do not bypass checking or treat unauthenticated key collection as verification. Review local inventory overrides too.

## Grafana and monitoring

Supply grafana_admin_password in an encrypted, untracked Ansible vars file. The monitoring role validates its presence and minimum length, then explicitly passes it to the remote Compose environment under no_log. The Compose template contains only a required-variable expression, not the secret. No actual secret is bundled. Avoid command-line secrets, diagnostic environment dumps, and publishing decrypted files. Docker administrators can inspect container environments; stronger secret handling remains future work.

The initialization value does not prove an existing Grafana administrator account was rotated. Verify and change existing credentials through supported administration tools.

Published monitoring ports bind to 127.0.0.1. Use authenticated SSH tunnels for remote interactive access. Readiness checks now target guest loopback but remain unexecuted. Container-network access, scrape targets, and permitted/blocked network paths still require testing.

## Disabled scripts and remaining checks

Deploy and cleanup scripts remain blocked. Replacement workflows must validate dependencies and addresses, preserve state, require reviewed plans, verify host keys, and report provisioning/configuration/health separately. Destruction requires reviewed targets and a saved destroy plan.

No credential rotation, historical cleanup, CI success, or runtime verification is claimed. See PIPELINE.md for the exact static checks and remaining compatibility work. Record commit, date, versions, commands, sanitized evidence, and outcomes when tests actually run.
