#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh node; then
    die "yarn requires Node in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  log_info "Enabling Corepack and activating yarn..."
  run_in_login_zsh 'corepack enable'
  run_in_login_zsh 'corepack prepare yarn@latest --activate'

  if ! command_exists_in_zsh yarn; then
    die "yarn was activated but is not available in zsh."
  fi

  log_info "Verifying yarn in zsh..."
  run_in_login_zsh 'yarn --version'

  log_success "yarn installation verified."
}

main "$@"
