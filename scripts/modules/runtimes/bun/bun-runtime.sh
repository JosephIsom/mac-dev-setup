#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "bun" "${BUN_VERSION}"

  log_info "Verifying Bun in zsh..."
  run_in_login_zsh 'bun --version'

  log_success "Bun runtime installation verified."
}

main "$@"
