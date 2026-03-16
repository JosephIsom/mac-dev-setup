#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_EZA_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/eza/eza-aliases.zsh"
TARGET_EZA_PLUGIN="$HOME/.zsh/plugins/eza-aliases.zsh"

install_eza_plugin() {
  install_managed_zsh_plugin "$REPO_EZA_PLUGIN" "$(basename "$TARGET_EZA_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "eza" "eza" "eza" --version
  install_eza_plugin

  [[ -f "$TARGET_EZA_PLUGIN" ]] || die "eza alias plugin file not found at $TARGET_EZA_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/eza-aliases.zsh\" ]]"
  run_in_login_zsh 'alias ls | grep -F "eza --icons=auto" >/dev/null'
  run_in_login_zsh 'alias lt | grep -F "eza --tree --level=2 --icons=auto" >/dev/null'
}

main "$@"
