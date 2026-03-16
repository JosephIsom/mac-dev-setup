#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  log_info "Applying Dock defaults..."
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock minimize-to-application -bool true
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock mru-spaces -bool false
  killall Dock >/dev/null 2>&1 || true
  log_success "Dock defaults applied."
}

main "$@"
