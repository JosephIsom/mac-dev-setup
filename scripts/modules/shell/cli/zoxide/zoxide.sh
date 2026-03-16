#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ZOXIDE_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/zoxide/zoxide-plugin.zsh"
TARGET_ZOXIDE_PLUGIN="$HOME/.zsh/plugins/zoxide-plugin.zsh"

install_zoxide_plugin() {
  install_managed_zsh_plugin "$REPO_ZOXIDE_PLUGIN" "$(basename "$TARGET_ZOXIDE_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "zoxide" "zoxide" "zoxide" --version
  install_zoxide_plugin

  [[ -f "$TARGET_ZOXIDE_PLUGIN" ]] || die "zoxide plugin file not found at $TARGET_ZOXIDE_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/zoxide-plugin.zsh\" ]]"
  run_in_login_zsh 'command -v zoxide >/dev/null 2>&1'
}

main "$@"
