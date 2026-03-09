#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "codex"

  if ! command_exists_in_zsh codex; then
    die "codex command not found in zsh after installation."
  fi

  log_info "Codex CLI version:"
  run_in_login_zsh 'codex --version || codex -V || true'

  log_success "Codex CLI installation verified."
}

main "$@"
