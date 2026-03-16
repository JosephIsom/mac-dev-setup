#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  ensure_local_bin_in_path

  log_info "Installing Kiro CLI via Kiro's official installer..."
  run_in_login_zsh 'curl -fsSL https://cli.kiro.dev/install | bash'

  if ! run_in_login_zsh 'command -v kiro-cli >/dev/null 2>&1'; then
    die "kiro-cli command was not found in zsh after installation."
  fi

  log_info "Installing Kiro command router..."
  run_in_login_zsh 'kiro-cli integrations install kiro-command-router'
  run_in_login_zsh 'kiro set-default cli'

  if ! run_in_login_zsh 'command -v kiro >/dev/null 2>&1'; then
    die "kiro command router was not found in zsh after installation."
  fi

  log_info "Kiro CLI version:"
  run_in_login_zsh 'kiro-cli --version || true'
  log_info "Kiro router status:"
  run_in_login_zsh 'kiro-cli integrations status || true'
  log_success "Kiro CLI installation verified."
}

main "$@"
