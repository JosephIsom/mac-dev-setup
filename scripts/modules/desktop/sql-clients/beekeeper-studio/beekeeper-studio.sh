#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Beekeeper Studio.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Beekeeper Studio already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "beekeeper-studio"
  fi

  [[ -d "$APP_PATH" ]] || die "Beekeeper Studio app not found at $APP_PATH after installation."
  log_success "Beekeeper Studio installation verified."
}

main "$@"
