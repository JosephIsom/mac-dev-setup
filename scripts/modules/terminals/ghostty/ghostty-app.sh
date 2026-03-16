#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Ghostty.app"
REPO_GHOSTTY_CONFIG="$REPO_ROOT/scripts/modules/terminals/ghostty/assets/config"
REPO_GHOSTTY_LOCAL_CONFIG="$REPO_ROOT/scripts/modules/terminals/ghostty/assets/local.conf"
REPO_GHOSTTY_THEME_DIR="$REPO_ROOT/scripts/modules/terminals/ghostty/assets/theme"
TARGET_GHOSTTY_DIR="$HOME/.config/ghostty"
TARGET_GHOSTTY_CONFIG="$TARGET_GHOSTTY_DIR/config"
TARGET_GHOSTTY_LOCAL_CONFIG="$TARGET_GHOSTTY_DIR/local.conf"
TARGET_GHOSTTY_THEME_DIR="$TARGET_GHOSTTY_DIR/themes"

backup_if_unmanaged() {
  local dest="$1"
  local backup="$2"

  [[ -f "$dest" ]] || return 0
  grep -Fq "mac-dev-setup managed Ghostty baseline" "$dest" && return 0

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

backup_if_different() {
  local src="$1"
  local dest="$2"
  local backup="$3"

  [[ -f "$dest" ]] || return 0
  cmp -s "$src" "$dest" && return 0

  if [[ -f "$backup" ]]; then
    log_warn "Overwriting $dest using existing backup at $backup"
    return 0
  fi

  cp "$dest" "$backup"
  log_warn "Backed up existing file: $dest -> $backup"
}

install_app() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Ghostty already exists at $APP_PATH. Leaving the existing app in place."
    return 0
  fi

  brew_install_cask "ghostty"
}

install_config() {
  [[ -f "$REPO_GHOSTTY_CONFIG" ]] || die "Missing repo-managed Ghostty config: $REPO_GHOSTTY_CONFIG"
  [[ -f "$REPO_GHOSTTY_LOCAL_CONFIG" ]] || die "Missing repo-managed Ghostty local config template: $REPO_GHOSTTY_LOCAL_CONFIG"
  [[ -d "$REPO_GHOSTTY_THEME_DIR" ]] || die "Missing repo-managed Ghostty theme directory: $REPO_GHOSTTY_THEME_DIR"
  mkdir -p "$TARGET_GHOSTTY_DIR"
  backup_if_unmanaged "$TARGET_GHOSTTY_CONFIG" "$TARGET_GHOSTTY_CONFIG.pre-mac-dev-setup.bak"
  cp "$REPO_GHOSTTY_CONFIG" "$TARGET_GHOSTTY_CONFIG"
  copy_repo_file_if_missing "$REPO_GHOSTTY_LOCAL_CONFIG" "$TARGET_GHOSTTY_LOCAL_CONFIG"

  mkdir -p "$TARGET_GHOSTTY_THEME_DIR"
  while IFS= read -r -d '' theme_file; do
    local target_theme
    target_theme="$TARGET_GHOSTTY_THEME_DIR/$(basename "$theme_file")"
    backup_if_different "$theme_file" "$target_theme" "$target_theme.pre-mac-dev-setup.bak"
    cp "$theme_file" "$target_theme"
  done < <(find "$REPO_GHOSTTY_THEME_DIR" -type f -name '*.conf' -print0 | sort -z)
}

verify_install() {
  [[ -d "$APP_PATH" ]] || die "Ghostty app not found at $APP_PATH after installation."
  [[ -f "$TARGET_GHOSTTY_CONFIG" ]] || die "Ghostty config not found at $TARGET_GHOSTTY_CONFIG after installation."
  [[ -f "$TARGET_GHOSTTY_LOCAL_CONFIG" ]] || die "Ghostty local config not found at $TARGET_GHOSTTY_LOCAL_CONFIG after installation."
  [[ -d "$TARGET_GHOSTTY_THEME_DIR" ]] || die "Ghostty theme directory not found at $TARGET_GHOSTTY_THEME_DIR after installation."
  [[ -f "$TARGET_GHOSTTY_THEME_DIR/apple-graphite-expanded-light.conf" ]] || die "Ghostty theme apple-graphite-expanded-light.conf not found after installation."
  [[ -f "$TARGET_GHOSTTY_THEME_DIR/apple-graphite-expanded-dark.conf" ]] || die "Ghostty theme apple-graphite-expanded-dark.conf not found after installation."
  grep -Fq "font-family = JetBrainsMono Nerd Font" "$TARGET_GHOSTTY_CONFIG" || die "Ghostty config does not set JetBrainsMono Nerd Font."
  grep -Fq "config-file = ?local.conf" "$TARGET_GHOSTTY_CONFIG" || die "Ghostty config does not include local override support."
}

main() {
  install_app
  install_config
  verify_install

  log_success "Ghostty installation verified."
}

main "$@"
