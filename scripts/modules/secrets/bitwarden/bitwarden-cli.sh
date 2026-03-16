#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_BW_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/secrets/bitwarden/bw-completion.zsh"
TARGET_BW_ZSH_PLUGIN="$HOME/.zsh/plugins/bw-completion.zsh"

install_bw_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_BW_ZSH_PLUGIN" "$(basename "$TARGET_BW_ZSH_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package "@bitwarden/cli@latest"

  if ! command_exists_in_zsh bw; then
    die "bw command not found in zsh after installation."
  fi

  install_bw_zsh_plugin

  if ! run_in_login_zsh 'bw completion --shell zsh >/dev/null 2>&1'; then
    die "Bitwarden CLI zsh completion generation failed."
  fi

  log_info "Bitwarden CLI version:"
  run_in_login_zsh 'bw --version'
  [[ -f "$TARGET_BW_ZSH_PLUGIN" ]] || die "Bitwarden zsh completion plugin not found at $TARGET_BW_ZSH_PLUGIN"
  log_success "Bitwarden CLI installation verified."
}

main "$@"
