#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh uv; then
    die "Python linters require uv in zsh. Enable INSTALL_PYTHON_UV or fix zsh runtime activation."
  fi

  log_info "Installing Ruff with uv tool..."
  run_in_login_zsh 'uv tool install ruff --force'

  if ! command_exists_in_zsh ruff; then
    die "ruff was installed but is not available in zsh."
  fi

  log_info "Verifying Ruff in zsh..."
  run_in_login_zsh 'ruff --version'

  log_success "Python linters installation verified."
}

main "$@"
