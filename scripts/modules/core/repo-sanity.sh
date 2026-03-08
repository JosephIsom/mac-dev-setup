#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

log_info "Checking repository structure..."

required_paths=(
  "README.md"
  "scripts/bootstrap.sh"
  "scripts/lib/common.sh"
  "scripts/lib/selection.sh"
  "config/profiles"
  "home"
  "docs"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$REPO_ROOT/$path" ]]; then
    die "Missing required path: $path"
  fi
done

log_success "Repository structure looks valid."