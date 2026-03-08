#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/iTerm.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "iTerm2 already exists at $APP_PATH. Leaving the existing app in place."
    log_success "iTerm2 presence verified."
    exit 0
  fi

  brew_install_cask "iterm2"

  [[ -d "$APP_PATH" ]] || die "iTerm2 app not found at $APP_PATH after installation."

  log_success "iTerm2 installation verified."
}

main "$@"