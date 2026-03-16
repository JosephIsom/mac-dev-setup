#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Codex.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Codex already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "codex-app"
  fi

  [[ -d "$APP_PATH" ]] || die "Codex app not found at $APP_PATH after installation."
  log_success "Codex installation verified."
}

main "$@"
