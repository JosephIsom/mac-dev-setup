#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Cursor.app"
REPO_CURSOR_SETTINGS="$REPO_ROOT/scripts/modules/editors/vscode/vscode-core-vscode-settings.jsonc"
TARGET_CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
TARGET_CURSOR_SETTINGS="$TARGET_CURSOR_USER_DIR/settings.json"
CURSOR_MANAGED_MARKER='"mac-dev-setup.managed": true'

backup_if_unmanaged() {
  local backup_file="$TARGET_CURSOR_SETTINGS.pre-mac-dev-setup.bak"

  [[ -f "$TARGET_CURSOR_SETTINGS" ]] || return 0
  grep -Fq "$CURSOR_MANAGED_MARKER" "$TARGET_CURSOR_SETTINGS" && return 0

  if [[ -f "$backup_file" ]]; then
    log_warn "Cursor settings are already backed up at $backup_file"
    return 0
  fi

  cp "$TARGET_CURSOR_SETTINGS" "$backup_file"
  log_warn "Backed up existing unmanaged Cursor settings to $backup_file"
}

install_settings() {
  [[ -f "$REPO_CURSOR_SETTINGS" ]] || die "Missing repo-managed Cursor settings source: $REPO_CURSOR_SETTINGS"
  mkdir -p "$TARGET_CURSOR_USER_DIR"
  backup_if_unmanaged
  cp "$REPO_CURSOR_SETTINGS" "$TARGET_CURSOR_SETTINGS"
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Cursor already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "cursor"
  fi

  [[ -d "$APP_PATH" ]] || die "Cursor app not found at $APP_PATH after installation."
  install_settings
  [[ -f "$TARGET_CURSOR_SETTINGS" ]] || die "Cursor settings not found at $TARGET_CURSOR_SETTINGS after installation."
  log_success "Cursor installation verified."
}

main "$@"
