#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Dropbox.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Dropbox already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "dropbox"
  fi

  [[ -d "$APP_PATH" ]] || die "Dropbox app not found at $APP_PATH after installation."
  log_success "Dropbox installation verified."
}

main "$@"
