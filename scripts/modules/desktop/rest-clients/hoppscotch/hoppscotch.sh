#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Hoppscotch.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Hoppscotch already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "hoppscotch"
  fi

  [[ -d "$APP_PATH" ]] || die "Hoppscotch app not found at $APP_PATH after installation."
  log_success "Hoppscotch installation verified."
}

main "$@"
