#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Kiro.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Kiro already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "kiro"
  fi

  [[ -d "$APP_PATH" ]] || die "Kiro app not found at $APP_PATH after installation."
  log_success "Kiro installation verified."
}

main "$@"
