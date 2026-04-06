#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh uv; then
    die "pre-commit requires uv in zsh. Enable the Python uv module or fix zsh runtime activation."
  fi

  uv_install_global_tool 'pre-commit@latest'

  if ! command_exists_in_zsh pre-commit; then
    die "pre-commit command not found in zsh after installation."
  fi

  log_info "pre-commit version:"
  run_in_login_zsh 'pre-commit --version'
  log_success "pre-commit installation verified."
}

main "$@"
