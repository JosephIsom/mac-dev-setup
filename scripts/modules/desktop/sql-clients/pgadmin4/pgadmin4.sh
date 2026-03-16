#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/pgAdmin 4.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "pgAdmin 4 already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "pgadmin4"
  fi

  [[ -d "$APP_PATH" ]] || die "pgAdmin 4 app not found at $APP_PATH after installation."
  log_success "pgAdmin 4 installation verified."
}

main "$@"
