#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh node; then
    die "pnpm requires Node in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  log_info "Enabling Corepack and activating pnpm..."
  run_in_login_zsh 'corepack enable'
  run_in_login_zsh 'corepack prepare pnpm@latest --activate'

  if ! command_exists_in_zsh pnpm; then
    die "pnpm was activated but is not available in zsh."
  fi

  log_info "Verifying pnpm in zsh..."
  run_in_login_zsh 'pnpm --version'

  log_success "pnpm installation verified."
}

main "$@"