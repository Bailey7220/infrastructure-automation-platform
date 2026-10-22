#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' \
  'Automated destruction is disabled pending a reviewed cleanup workflow.' \
  'No Terraform command has been executed by this script.' \
  'Preserve private state and review a saved destroy plan before any manual destruction.' >&2
exit 1
