#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Windsurf.app"
REPO_WINDSURF_SETTINGS="$REPO_ROOT/scripts/modules/editors/vscode/vscode-core-vscode-settings.jsonc"
TARGET_WINDSURF_USER_DIR="$HOME/Library/Application Support/Windsurf/User"
TARGET_WINDSURF_SETTINGS="$TARGET_WINDSURF_USER_DIR/settings.json"
WINDSURF_MANAGED_MARKER='"mac-dev-setup.managed": true'

backup_if_unmanaged() {
  local backup_file="$TARGET_WINDSURF_SETTINGS.pre-mac-dev-setup.bak"

  [[ -f "$TARGET_WINDSURF_SETTINGS" ]] || return 0
  grep -Fq "$WINDSURF_MANAGED_MARKER" "$TARGET_WINDSURF_SETTINGS" && return 0

  if [[ -f "$backup_file" ]]; then
    log_warn "Windsurf settings are already backed up at $backup_file"
    return 0
  fi

  cp "$TARGET_WINDSURF_SETTINGS" "$backup_file"
  log_warn "Backed up existing unmanaged Windsurf settings to $backup_file"
}

install_settings() {
  [[ -f "$REPO_WINDSURF_SETTINGS" ]] || die "Missing repo-managed Windsurf settings source: $REPO_WINDSURF_SETTINGS"
  mkdir -p "$TARGET_WINDSURF_USER_DIR"
  backup_if_unmanaged
  cp "$REPO_WINDSURF_SETTINGS" "$TARGET_WINDSURF_SETTINGS"
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Windsurf already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "windsurf"
  fi

  [[ -d "$APP_PATH" ]] || die "Windsurf app not found at $APP_PATH after installation."
  install_settings
  [[ -f "$TARGET_WINDSURF_SETTINGS" ]] || die "Windsurf settings not found at $TARGET_WINDSURF_SETTINGS after installation."
  log_warn "Windsurf can optionally install a 'windsurf' PATH command during onboarding."
  log_success "Windsurf installation verified."
}

main "$@"
