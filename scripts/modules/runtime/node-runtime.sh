#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists mise || die "mise must be installed before node-runtime runs."

  log_info "Installing Node via mise: ${NODE_VERSION}"
  mise use -g "node@${NODE_VERSION}"

  log_info "Verifying Node in zsh..."
  run_in_login_zsh 'node --version'
  run_in_login_zsh 'npm --version'
  run_in_login_zsh 'corepack --version'

  log_success "Node runtime installation verified."
}

main "$@"