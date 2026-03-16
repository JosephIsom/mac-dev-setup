#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  log_info "Applying Finder defaults..."
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  killall Finder >/dev/null 2>&1 || true
  log_success "Finder defaults applied."
}

main "$@"
