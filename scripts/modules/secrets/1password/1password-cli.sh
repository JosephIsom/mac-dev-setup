#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_OP_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/secrets/1password/op-completion.zsh"
TARGET_OP_ZSH_PLUGIN="$HOME/.zsh/plugins/op-completion.zsh"

install_op_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_OP_ZSH_PLUGIN" "$(basename "$TARGET_OP_ZSH_PLUGIN")" >/dev/null
}

main() {
  brew_install_cask "1password-cli"

  if ! command_exists_in_zsh op; then
    die "op command not found in zsh after installation."
  fi

  install_op_zsh_plugin

  if ! run_in_login_zsh 'op completion zsh >/dev/null 2>&1'; then
    die "1Password CLI zsh completion generation failed."
  fi

  log_info "1Password CLI version:"
  run_in_login_zsh 'op --version'
  [[ -f "$TARGET_OP_ZSH_PLUGIN" ]] || die "1Password zsh completion plugin not found at $TARGET_OP_ZSH_PLUGIN"
  log_success "1Password CLI installation verified."
}

main "$@"
