#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Windsurf.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Windsurf already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "windsurf"
  fi

  [[ -d "$APP_PATH" ]] || die "Windsurf app not found at $APP_PATH after installation."
  log_warn "Windsurf can optionally install a 'windsurf' PATH command during onboarding."
  log_success "Windsurf installation verified."
}

main "$@"
