#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ ! -f "${REPO_ROOT}/config/.env.local" ]]; then
  echo "Missing required file: ${REPO_ROOT}/config/.env.local" >&2
  echo "Create it from config/.env.example" >&2
  exit 1
fi

# shellcheck disable=SC1091
source "${REPO_ROOT}/config/.env.local"

echo "Loaded environment configuration for SNO playbooks."
