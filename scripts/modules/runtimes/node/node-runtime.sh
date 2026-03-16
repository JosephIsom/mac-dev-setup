#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "node" "${NODE_VERSION}"

  log_info "Verifying Node in zsh..."
  run_in_login_zsh 'node --version'
  run_in_login_zsh 'npm --version'
  run_in_login_zsh 'corepack --version'

  log_success "Node runtime installation verified."
}

main "$@"
