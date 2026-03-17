#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
LIB_DIR="${LIB_DIR:-$REPO_ROOT/scripts/lib}"

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

CONFIG_DIR="${CONFIG_DIR:-$REPO_ROOT/config}"
MODULES_DIR="${MODULES_DIR:-$REPO_ROOT/scripts/modules}"
PREREQUISITES_DIR="${PREREQUISITES_DIR:-$REPO_ROOT/scripts/prerequisites}"

log_info "Checking repository structure..."

required_paths=(
  "scripts/bootstrap.sh"
  "scripts/bootstrap-local-edge.sh"
  "scripts/lib/common.sh"
  "scripts/prerequisites/prerequisites.sh"
  "scripts/prerequisites"
  "scripts/modules"
  "local-edge"
  "config/user.env.example"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$REPO_ROOT/$path" ]]; then
    die "Missing required path: $path"
  fi
done

log_info "Checking bootstrap script references..."

while IFS= read -r raw_path; do
  if [[ -z "$raw_path" ]]; then
    continue
  fi

  resolved_path="$(eval "printf '%s' \"$raw_path\"")"

  if [[ ! -e "$resolved_path" ]]; then
    die "Bootstrap references missing path: $raw_path"
  fi
done < <(
  sed -n 's/^[[:space:]]*#\{0,1\}[[:space:]]*run_script_path "\(.*\)".*/\1/p' \
    "$REPO_ROOT/scripts/bootstrap.sh"
)

log_info "Checking local-edge entrypoint references..."

while IFS= read -r script_name; do
  if [[ -z "$script_name" ]]; then
    continue
  fi

  if [[ ! -e "$REPO_ROOT/local-edge/scripts/$script_name" ]]; then
    die "Local-edge entrypoint references missing script: local-edge/scripts/$script_name"
  fi
done < <(
  sed -n 's/.*run_local_edge_script "\([^"]*\)".*/\1/p' \
    "$REPO_ROOT/scripts/bootstrap-local-edge.sh"
)

log_success "Repository structure looks valid."
