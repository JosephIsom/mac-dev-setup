#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

main() {
  log_info "Applying screenshot defaults..."
  mkdir -p "$SCREENSHOT_DIR"
  defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  killall SystemUIServer >/dev/null 2>&1 || true
  log_success "Screenshot defaults applied."
}

main "$@"
