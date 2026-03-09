#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh npm; then
    die "TypeScript installation requires npm in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  log_info "Installing global TypeScript tooling..."
  run_in_login_zsh 'npm install -g typescript'

  if ! command_exists_in_zsh tsc; then
    die "tsc was installed but is not available in zsh."
  fi

  log_info "Verifying TypeScript in zsh..."
  run_in_login_zsh 'tsc --version'

  log_success "TypeScript installation verified."
}

main "$@"