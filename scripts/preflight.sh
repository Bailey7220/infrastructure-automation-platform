#!/usr/bin/env bash
set +x
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf '%s\n' 'Usage: bash scripts/preflight.sh /path/to/guest-public-key.pub' >&2
  exit 2
fi

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0
pass() { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1" >&2; failures=$((failures + 1)); }

for tool in terraform ansible-playbook ansible-galaxy ssh; do
  if command -v "$tool" >/dev/null 2>&1; then
    pass "$tool is available"
  else
    fail "$tool is missing from PATH"
  fi
done

for relative in terraform/main.tf terraform/variables.tf terraform/.terraform.lock.hcl terraform/terraform.tfvars ansible/inventory.ini ansible/playbook.yml ansible/requirements.yml; do
  if [[ -f "$root/$relative" && -r "$root/$relative" && -s "$root/$relative" ]]; then
    pass "$relative exists and is readable and nonempty"
  else
    fail "$relative is missing, unreadable, or empty"
  fi
done

if [[ -f "$1" && -r "$1" && -s "$1" ]]; then
  pass 'Explicit guest public-key path is readable and nonempty (contents not validated)'
else
  fail 'Explicit guest public-key path is missing, unreadable, or empty'
fi

if [[ -n ${PROXMOX_VE_ENDPOINT:-} ]]; then
  pass 'PROXMOX_VE_ENDPOINT is set (value not printed or validated)'
else
  fail 'PROXMOX_VE_ENDPOINT is not set'
fi

if [[ -n ${PROXMOX_VE_API_TOKEN:-} ]]; then
  pass 'API-token authentication input is present (not authenticated)'
elif [[ -n ${PROXMOX_VE_USERNAME:-} && -n ${PROXMOX_VE_PASSWORD:-} ]]; then
  pass 'Username/password authentication inputs are present (not authenticated)'
else
  fail 'Set PROXMOX_VE_API_TOKEN or both PROXMOX_VE_USERNAME and PROXMOX_VE_PASSWORD locally'
fi

printf '%s\n' 'No Terraform, Ansible, or SSH operation was run; no network check was performed.'
printf '%s\n' 'This check does not establish valid configuration, credential rotation, state safety, or deployment readiness.'
if (( failures > 0 )); then
  printf 'Preflight failed: %s check(s).\n' "$failures" >&2
  exit 1
fi
printf '%s\n' 'Local presence checks passed. Deployment and cleanup remain disabled.'
