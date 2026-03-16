#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/TablePlus.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "TablePlus already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "tableplus"
  fi

  [[ -d "$APP_PATH" ]] || die "TablePlus app not found at $APP_PATH after installation."
  log_success "TablePlus installation verified."
}

main "$@"
