#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Google Chrome.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Google Chrome already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "google-chrome"
  fi

  [[ -d "$APP_PATH" ]] || die "Google Chrome app not found at $APP_PATH after installation."
  log_success "Google Chrome installation verified."
}

main "$@"
