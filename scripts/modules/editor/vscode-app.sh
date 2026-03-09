#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Visual Studio Code.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "VS Code already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "visual-studio-code"
  fi

  [[ -d "$APP_PATH" ]] || die "VS Code app not found at $APP_PATH after installation."

  log_success "VS Code installation verified."
}

main "$@"