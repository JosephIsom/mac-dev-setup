#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/ChatGPT.app"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "ChatGPT already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "chatgpt"
  fi

  [[ -d "$APP_PATH" ]] || die "ChatGPT app not found at $APP_PATH after installation."
  log_success "ChatGPT installation verified."
}

main "$@"
