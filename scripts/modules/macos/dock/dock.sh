#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  log_info "Applying Dock defaults..."
  # -----------------------------------------------------

  # defaults write com.apple.dock autohide -bool true

  # defaults write com.apple.dock minimize-to-application -bool true

  # Set the Dock position (left, bottom, or right)
  # defaults write com.apple.dock "orientation" -string "bottom"

  # Set the

  # Set the icon size of Dock items in pixels (default: 48)
  defaults write com.apple.dock "tilesize" -int "24"

  # Show recently used apps in a separate section of the Dock (true = show, false = hide)
  defaults write com.apple.dock show-recents -bool false

  # Choose whether to rearrange Spaces automatically (true = yes, false = no)
  defaults write com.apple.dock mru-spaces -bool false

  # -----------------------------------------------------
  killall Dock >/dev/null 2>&1 || true
  log_success "Dock defaults applied."
}

main "$@"
