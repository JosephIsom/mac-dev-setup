#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/HTTPie.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "HTTPie Desktop already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "httpie-desktop"
  fi

  [[ -d "$APP_PATH" ]] || die "HTTPie Desktop app not found at $APP_PATH after installation."
  log_success "HTTPie Desktop installation verified."
}

main "$@"
