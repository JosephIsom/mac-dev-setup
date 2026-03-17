#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

verify_cursor_cli() {
  if run_in_login_zsh 'command -v cursor-agent >/dev/null 2>&1'; then
    log_info "Cursor CLI command found: $(run_in_login_zsh 'command -v cursor-agent')"
    return 0
  fi

  if run_in_login_zsh 'command -v cursor >/dev/null 2>&1'; then
    log_info "Cursor command found: $(run_in_login_zsh 'command -v cursor')"
    return 0
  fi

  die "Cursor CLI command was not found in zsh after installation."
}

main() {
  brew_install_cask "cursor-cli"

  verify_cursor_cli
  log_success "Cursor CLI installation verified."
}

main "$@"
