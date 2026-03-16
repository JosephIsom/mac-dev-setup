#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/iTerm.app"
REPO_ITERM_PROFILE="$REPO_ROOT/scripts/modules/terminals/iterm2/assets/00-mac-dev-setup.json"
TARGET_ITERM_DYNAMIC_PROFILE_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
TARGET_ITERM_DYNAMIC_PROFILE="$TARGET_ITERM_DYNAMIC_PROFILE_DIR/00-mac-dev-setup.json"

backup_if_unmanaged() {
  local dest="$1"
  local backup="$2"

  [[ -f "$dest" ]] || return 0
  grep -Fq "\"Guid\": \"8A4A6C8C-0F44-4C3B-BD78-7C6A7F1F1A10\"" "$dest" && return 0

  if [[ -f "$backup" ]]; then
    log_warn "Overwriting $dest using existing backup at $backup"
    return 0
  fi

  cp "$dest" "$backup"
  log_warn "Backed up existing unmanaged file: $dest -> $backup"
}

install_dynamic_profile() {
  [[ -f "$REPO_ITERM_PROFILE" ]] || die "Missing repo-managed iTerm2 dynamic profile: $REPO_ITERM_PROFILE"

  mkdir -p "$TARGET_ITERM_DYNAMIC_PROFILE_DIR"
  backup_if_unmanaged "$TARGET_ITERM_DYNAMIC_PROFILE" "$TARGET_ITERM_DYNAMIC_PROFILE.pre-mac-dev-setup.bak"
  cp "$REPO_ITERM_PROFILE" "$TARGET_ITERM_DYNAMIC_PROFILE"
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "iTerm2 already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "iterm2"
  fi

  [[ -d "$APP_PATH" ]] || die "iTerm2 app not found at $APP_PATH after installation."
  install_dynamic_profile
  [[ -f "$TARGET_ITERM_DYNAMIC_PROFILE" ]] || die "iTerm2 dynamic profile not found at $TARGET_ITERM_DYNAMIC_PROFILE after installation."
  grep -Fq '"Name": "mac-dev-setup"' "$TARGET_ITERM_DYNAMIC_PROFILE" || die "iTerm2 dynamic profile is missing the managed profile name."
  grep -Fq '"Normal Font": "JetBrainsMono Nerd Font 14"' "$TARGET_ITERM_DYNAMIC_PROFILE" || die "iTerm2 dynamic profile does not set JetBrainsMono Nerd Font."

  log_success "iTerm2 installation verified."
  log_warn "Set the iTerm2 profile named 'mac-dev-setup' as your default profile if you want the managed font and baseline behavior."
}

main "$@"
