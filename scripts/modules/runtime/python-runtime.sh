#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists mise || die "mise must be installed before python-runtime runs."

  log_info "Installing Python via mise: ${PYTHON_VERSION}"
  mise use -g "python@${PYTHON_VERSION}"

  log_info "Verifying Python in zsh..."
  run_in_login_zsh 'python --version'
  run_in_login_zsh 'python3 --version || true'

  log_success "Python runtime installation verified."
}

main "$@"