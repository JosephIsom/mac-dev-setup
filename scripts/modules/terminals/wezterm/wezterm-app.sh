#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/WezTerm.app"
REPO_WEZTERM_CONFIG="$REPO_ROOT/scripts/modules/terminals/wezterm/assets/wezterm.lua"
REPO_WEZTERM_LOCAL_CONFIG="$REPO_ROOT/scripts/modules/terminals/wezterm/assets/local.lua"
TARGET_WEZTERM_DIR="$HOME/.config/wezterm"
TARGET_WEZTERM_CONFIG="$TARGET_WEZTERM_DIR/wezterm.lua"
TARGET_WEZTERM_LOCAL_CONFIG="$TARGET_WEZTERM_DIR/local.lua"

backup_if_unmanaged() {
  local dest="$1"
  local backup="$2"

  [[ -f "$dest" ]] || return 0
  grep -Fq "mac-dev-setup managed WezTerm baseline" "$dest" && return 0

  if [[ -f "$backup" ]]; then
    log_warn "Overwriting $dest using existing backup at $backup"
    return 0
  fi

  cp "$dest" "$backup"
  log_warn "Backed up existing unmanaged file: $dest -> $backup"
}

copy_repo_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || return 0

  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log_success "Created $dest from repo template"
}

install_app() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "WezTerm already exists at $APP_PATH. Leaving the existing app in place."
    return 0
  fi

  brew_install_cask "wezterm"
}

install_config() {
  [[ -f "$REPO_WEZTERM_CONFIG" ]] || die "Missing repo-managed WezTerm config: $REPO_WEZTERM_CONFIG"
  [[ -f "$REPO_WEZTERM_LOCAL_CONFIG" ]] || die "Missing repo-managed WezTerm local config template: $REPO_WEZTERM_LOCAL_CONFIG"

  mkdir -p "$TARGET_WEZTERM_DIR"
  backup_if_unmanaged "$TARGET_WEZTERM_CONFIG" "$TARGET_WEZTERM_CONFIG.pre-mac-dev-setup.bak"
  cp "$REPO_WEZTERM_CONFIG" "$TARGET_WEZTERM_CONFIG"
  copy_repo_file_if_missing "$REPO_WEZTERM_LOCAL_CONFIG" "$TARGET_WEZTERM_LOCAL_CONFIG"
}

verify_install() {
  [[ -d "$APP_PATH" ]] || die "WezTerm app not found at $APP_PATH after installation."
  [[ -f "$TARGET_WEZTERM_CONFIG" ]] || die "WezTerm config not found at $TARGET_WEZTERM_CONFIG after installation."
  [[ -f "$TARGET_WEZTERM_LOCAL_CONFIG" ]] || die "WezTerm local config not found at $TARGET_WEZTERM_LOCAL_CONFIG after installation."
  grep -Fq "local colors_dark =" "$TARGET_WEZTERM_CONFIG" || die "WezTerm config does not define the managed dark palette."
  grep -Fq "local colors_light =" "$TARGET_WEZTERM_CONFIG" || die "WezTerm config does not define the managed light palette."
  grep -Fq "JetBrainsMono Nerd Font" "$TARGET_WEZTERM_CONFIG" || die "WezTerm config does not set JetBrainsMono Nerd Font."
}

main() {
  install_app
  install_config
  verify_install

  log_success "WezTerm installation verified."
}

main "$@"
