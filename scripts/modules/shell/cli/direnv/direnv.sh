#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DIRENV_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/direnv/direnv-plugin.zsh"
TARGET_DIRENV_PLUGIN="$HOME/.zsh/plugins/direnv-plugin.zsh"

install_direnv_plugin() {
  install_managed_zsh_plugin "$REPO_DIRENV_PLUGIN" "$(basename "$TARGET_DIRENV_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "direnv" "direnv" "direnv" version
  install_direnv_plugin

  [[ -f "$TARGET_DIRENV_PLUGIN" ]] || die "direnv plugin file not found at $TARGET_DIRENV_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/direnv-plugin.zsh\" ]]"
  run_in_login_zsh 'command -v direnv >/dev/null 2>&1'
  run_in_login_zsh 'direnv hook zsh >/dev/null'
}

main "$@"
