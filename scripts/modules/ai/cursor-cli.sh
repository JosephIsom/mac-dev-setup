#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

LOCAL_BIN_EXPORT='export PATH="$HOME/.local/bin:$PATH"'

ensure_local_bin_in_path() {
  local local_zsh="$HOME/.config/zsh/conf.d/90-local.zsh"

  mkdir -p "$(dirname "$local_zsh")"
  touch "$local_zsh"

  if ! grep -Fqx "$LOCAL_BIN_EXPORT" "$local_zsh" 2>/dev/null; then
    printf '\n%s\n' "$LOCAL_BIN_EXPORT" >> "$local_zsh"
    log_success "Added ~/.local/bin PATH entry to $local_zsh"
  fi
}

verify_cursor_cli() {
  if run_in_login_zsh 'command -v cursor-agent >/dev/null 2>&1'; then
    log_info "Cursor CLI command found: cursor-agent"
    run_in_login_zsh 'cursor-agent --version || true'
    return 0
  fi

  if run_in_login_zsh 'command -v cursor >/dev/null 2>&1'; then
    log_info "Cursor command found: cursor"
    run_in_login_zsh 'cursor --version || true'
    return 0
  fi

  die "Cursor CLI command was not found in zsh after installation."
}

main() {
  ensure_local_bin_in_path

  log_info "Installing Cursor CLI via Cursor's official installer..."
  run_in_login_zsh 'curl https://cursor.com/install -fsS | bash'

  verify_cursor_cli
  log_success "Cursor CLI installation verified."
}

main "$@"
