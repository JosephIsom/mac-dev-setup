#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh uv; then
    die "pre-commit requires uv in zsh. Enable INSTALL_PYTHON_UV or fix zsh runtime activation."
  fi

  log_info "Installing pre-commit with uv tool..."
  run_in_login_zsh 'uv tool install pre-commit --force'

  if ! command_exists_in_zsh pre-commit; then
    die "pre-commit was installed but is not available in zsh."
  fi

  log_info "Verifying pre-commit in zsh..."
  run_in_login_zsh 'pre-commit --version'

  log_success "pre-commit installation verified."
}

main "$@"
