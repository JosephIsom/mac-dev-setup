#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "python" "${PYTHON_VERSION}"

  log_info "Verifying Python in zsh..."
  run_in_login_zsh 'python --version'
  run_in_login_zsh 'python3 --version || true'

  log_success "Python runtime installation verified."
}

main "$@"
