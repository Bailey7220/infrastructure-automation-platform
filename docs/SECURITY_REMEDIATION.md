# Security remediation and verification boundaries

## Repository edits versus live remediation

This source change does not rotate credentials, rewrite Git history, reconfigure running services, or establish deployment success. Rotate or revoke exposed credentials at their actual services and assess historical copies separately. Do not publish replacement secrets or Terraform state.

## SSH

Verify host fingerprints through a trusted console or other authenticated channel before enrolling them in the controller's known_hosts file. Do not bypass host-key checking or treat unauthenticated key collection as verification. Review any local inventory overrides as well.

## Grafana and monitoring

The generated Compose project requires a nonempty GRAFANA_ADMIN_PASSWORD in its runtime environment or a private local .env file. This is an interim local configuration, not a complete secret-management system. Keep that file out of Git and restrict its permissions. Do not put actual secrets in examples or command logs.

Ansible's existing Compose task has not been adapted or tested with this runtime input. Do not assume an environment variable on the controller is automatically available to the remote task. Dependency migration and explicit runtime-secret handling are required before deployment.

Changing an initialization value does not establish that an existing Grafana account has been rotated. Verify and change existing credentials through the service's supported administration workflow.

Published ports bind to 127.0.0.1. Use an authenticated SSH tunnel for interactive remote access. Container-network access and intended scrape paths still need testing. Existing Ansible checks that target a guest interface address must be updated and tested; do not restore broad port exposure merely to make a check pass.

## Disabled scripts

The former deploy and cleanup scripts are intentionally blocked. Their replacements must validate dependencies, resolve paths independently of the calling directory, preserve private state, require reviewed plans, validate management addresses, and report provisioning, configuration, and health outcomes separately. Destruction requires a reviewed destroy plan and explicit target confirmation.

## Validation record

No deployment, credential rotation, history remediation, or runtime test is claimed by this commit. Record the commit, commands, tool versions, date, outcomes, and sanitized evidence when verification is actually performed.
