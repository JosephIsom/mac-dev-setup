#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "uv"

  if ! command_exists_in_zsh uv; then
    die "uv was installed but is not available in zsh."
  fi

  log_info "Verifying uv in zsh..."
  run_in_login_zsh 'uv --version'

  log_success "uv installation verified."
}

main "$@"