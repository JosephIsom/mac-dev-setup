#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"


# TODO: Incomplete - research the items I want in here.
main() {
  log_info "Applying Finder defaults..."
# -----------------------------------------------------


  # Show all file extensions in the Finder. (default: false)
  # defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
  defaults delete NSGlobalDomain "AppleShowAllExtensions"


  # Show hidden files in the Finder. You can toggle the value using ⌘ cmd+⇧ shift+. (default: false)
  # defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
  defaults delete com.apple.finder "AppleShowAllFiles"


  # Show path bar in the bottom of the Finder windows (default: false)
  defaults write com.apple.finder "ShowPathbar" -bool "true"
  # defaults delete com.apple.finder "ShowPathbar"


  # Set the default view style for folders without custom setting
  # Valid options: icnv (icon view), clmv (column view), Flwv (cover flow view), Nlsv (list view)
  # default value is "icnv" (icon view)
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
  # defaults delete com.apple.finder "FXPreferredViewStyle"


  # Keep folders on top when sorting by name (default: false)
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
  # defaults delete com.apple.finder "_FXSortFoldersFirst"


  # Set the default search scope when performing a search
  # Valid options: "SCcf" (current folder), "SCev" (entire Mac), "SCsp" (previous search scope)
  # default value is "SCev" (entire Mac)
  defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
  # defaults delete com.apple.finder "FXDefaultSearchScope"


  # Remove items from the Trash after 30 days (default: false)
  # defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
  defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "false"
  # defaults delete com.apple.finder "FXRemoveOldTrashItems"


  # Choose whether to display a warning when changing a file extension. (default: true)
  # defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
  defaults delete com.apple.finder "FXEnableExtensionChangeWarning"

  # defaults write com.apple.finder ShowPathbar -bool true
  # defaults write com.apple.finder ShowStatusBar -bool true
  # defaults write com.apple.finder _FXSortFoldersFirst -bool true
  # defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  # defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  # defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


  # -----------------------------------------------------
  killall Finder >/dev/null 2>&1 || true
  log_success "Finder defaults applied."
}
 defaults write com.apple.dock mru-spaces -bool false
main "$@"
