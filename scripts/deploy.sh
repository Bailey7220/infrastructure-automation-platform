#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' \
  'Deployment automation is disabled pending dependency and end-to-end validation.' \
  'No Terraform or Ansible command has been executed by this script.' \
  'Read README.md, PROJECT_STATUS.md, and docs/SECURITY_REMEDIATION.md.' >&2
exit 1
