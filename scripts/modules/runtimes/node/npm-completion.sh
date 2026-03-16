#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_NPM_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/node/npm-completion.zsh"
TARGET_NPM_ZSH_PLUGIN="$HOME/.zsh/plugins/npm-completion.zsh"

install_npm_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_NPM_ZSH_PLUGIN" "$(basename "$TARGET_NPM_ZSH_PLUGIN")" >/dev/null
}

main() {
  if ! command_exists_in_zsh npm; then
    die "npm completion requires npm in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  install_npm_zsh_plugin
  run_in_login_zsh 'npm completion >/dev/null 2>&1'
  [[ -f "$TARGET_NPM_ZSH_PLUGIN" ]] || die "npm zsh completion plugin not found at $TARGET_NPM_ZSH_PLUGIN"
  log_success "npm completion integration verified."
}

main "$@"
