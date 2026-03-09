#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/JetBrains Toolbox.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "JetBrains Toolbox already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "jetbrains-toolbox"
  fi

  [[ -d "$APP_PATH" ]] || die "JetBrains Toolbox app not found at $APP_PATH after installation."

  log_success "JetBrains Toolbox installation verified."
  log_warn "Open JetBrains Toolbox, sign in, and install IntelliJ IDEA from Toolbox."
}

main "$@"
