#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Codex.app"
DOWNLOAD_URL="https://openai.com/codex/get-started/"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_success "Codex app already exists at $APP_PATH"
    return 0
  fi

  log_warn "Codex app is installed via OpenAI's official macOS download flow."
  log_warn "Opening the official Codex app download/get-started page..."
  open "$DOWNLOAD_URL"

  log_warn "After installing Codex.app into /Applications, rerun bootstrap or verify manually."
}

main "$@"
