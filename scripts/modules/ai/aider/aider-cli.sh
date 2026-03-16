#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  command_exists_in_zsh uv || die "uv must be available in zsh before installing aider."

  log_info "Installing/updating Aider with uv..."
  run_in_login_zsh "uv tool install --python python3.12 --with pip 'aider-chat@latest' --force"

  if ! command_exists_in_zsh aider; then
    die "aider command not found in zsh after installation."
  fi

  log_info "Aider CLI version:"
  run_in_login_zsh 'aider --version || true'
  log_success "Aider CLI installation verified."
}

main "$@"
