#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Cursor.app"
DOWNLOAD_URL="https://cursor.com/download"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_success "Cursor editor already exists at $APP_PATH"
    return 0
  fi

  log_warn "Cursor editor is installed via Cursor's official download flow."
  log_warn "Opening the official Cursor download page..."
  open "$DOWNLOAD_URL"

  log_warn "After installing Cursor.app into /Applications, rerun bootstrap or verify manually."
}

main "$@"
