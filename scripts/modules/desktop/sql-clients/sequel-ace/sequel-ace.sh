#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Sequel Ace.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Sequel Ace already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "sequel-ace"
  fi

  [[ -d "$APP_PATH" ]] || die "Sequel Ace app not found at $APP_PATH after installation."
  log_success "Sequel Ace installation verified."
}

main "$@"
