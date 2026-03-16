#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  log_info "Applying keyboard and input defaults..."
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
  killall SystemUIServer >/dev/null 2>&1 || true
  log_success "Keyboard and input defaults applied."
}

main "$@"
