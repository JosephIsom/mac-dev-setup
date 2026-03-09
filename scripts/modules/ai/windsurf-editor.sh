#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Windsurf.app"
DOWNLOAD_URL="https://windsurf.com/download"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_success "Windsurf editor already exists at $APP_PATH"
    return 0
  fi

  log_warn "Windsurf editor is installed via Windsurf's official download flow."
  log_warn "Opening the official Windsurf download page..."
  open "$DOWNLOAD_URL"

  log_warn "After installing Windsurf.app into /Applications, rerun bootstrap or verify manually."
  log_warn "Windsurf can optionally install a 'windsurf' PATH command during onboarding."
}

main "$@"
