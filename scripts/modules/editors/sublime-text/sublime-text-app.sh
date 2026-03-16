#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Sublime Text.app"
REPO_SUBLIME_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/editors/sublime-text/sublime-text-path.zsh"
TARGET_SUBLIME_ZSH_PLUGIN="$HOME/.zsh/plugins/sublime-text-path.zsh"

install_sublime_path_plugin() {
  install_managed_zsh_plugin "$REPO_SUBLIME_ZSH_PLUGIN" "$(basename "$TARGET_SUBLIME_ZSH_PLUGIN")" >/dev/null
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Sublime Text already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "sublime-text"
  fi

  [[ -d "$APP_PATH" ]] || die "Sublime Text app not found at $APP_PATH after installation."
  install_sublime_path_plugin
  run_in_login_zsh 'command -v subl >/dev/null 2>&1'
  [[ -f "$TARGET_SUBLIME_ZSH_PLUGIN" ]] || die "Sublime Text zsh path plugin not found at $TARGET_SUBLIME_ZSH_PLUGIN"
  log_success "Sublime Text installation verified."
}

main "$@"
