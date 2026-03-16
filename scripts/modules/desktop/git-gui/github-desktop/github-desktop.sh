#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/GitHub Desktop.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "GitHub Desktop already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "github"
  fi

  [[ -d "$APP_PATH" ]] || die "GitHub Desktop app not found at $APP_PATH after installation."
  log_success "GitHub Desktop installation verified."
}

main "$@"
