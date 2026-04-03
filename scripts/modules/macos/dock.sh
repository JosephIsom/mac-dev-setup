#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

# TODO: Incomplete - research the items I want in here.

main() {
  log_info "Applying Dock defaults..."
  # -----------------------------------------------------

  # Set the Dock position (left, bottom, or right)
  defaults write com.apple.dock "orientation" -string "bottom"
  # defaults delete com.apple.dock "orientation"
]
  # Set the icon size of Dock items in pixels (default: 48)
  defaults write com.apple.dock "tilesize" -int "24"
  # defaults delete com.apple.dock "tilesize"

  # Autohide the Dock. You can toggle the Dock using ⌥ alt+⌘ cmd+d.
  defaults write com.apple.dock autohide -bool "false"
  # defaults delete com.apple.dock autohide

  # Change the Dock opening and closing animation times. (default: 0.5)
  # com.apple.dock autohide must be set to true
  # defaults write com.apple.dock "autohide-time-modifier" -float "0.5"
  defaults delete com.apple.dock "autohide-time-modifier"

  # Change the Dock opening delay. (default: 0.2)
  # com.apple.dock autohide must be set to true
  # defaults write com.apple.dock "autohide-delay" -float "0.2"
  defaults delete com.apple.dock "autohide-delay"

  # Show recently used apps in a separate section of the Dock (true = show, false = hide)
  defaults write com.apple.dock show-recents -bool false
  # defaults delete com.apple.dock "show-recents"

  # Change the Dock minimize animation.
  # Valid options: genie, scale, suck (default: genie)
  # defaults write com.apple.dock "mineffect" -string "genie"
  defaults delete com.apple.dock "mineffect"

  # -----------------------------------------------------
  killall Dock >/dev/null 2>&1 || true
  log_success "Dock defaults applied."
}

main "$@"
