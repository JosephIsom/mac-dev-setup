#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Firefox.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Firefox already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "firefox"
  fi

  [[ -d "$APP_PATH" ]] || die "Firefox app not found at $APP_PATH after installation."
  log_success "Firefox installation verified."
}

main "$@"
