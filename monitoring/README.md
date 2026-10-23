# Standalone monitoring placeholders

The following files in this directory are empty placeholders, not a working standalone monitoring stack:

- `docker-compose-prom-graf.yaml`
- `prometheus.yml`
- `setup.sh`

Do not use this directory as deployment instructions or treat the empty setup script as evidence of a successful installation.

## Implemented source path

The monitoring implementation in source is the [Ansible monitoring role](../ansible/roles/monitoring/), included by [the playbook](../ansible/playbook.yml). Refer to the [root README](../README.md), [pipeline guide](../docs/PIPELINE.md), and [security-remediation guide](../docs/SECURITY_REMEDIATION.md) for its inputs and limitations.

Passing static checks or preflight fixture tests does not establish that this role has executed, that monitoring scrapes work, or that dashboards and network isolation have been verified. Deployment and cleanup scripts remain disabled.

These placeholders are retained for now; they are not an alternative supported deployment path.
