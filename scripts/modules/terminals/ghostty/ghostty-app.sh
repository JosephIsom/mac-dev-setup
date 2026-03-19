#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GHOSTTY_CONFIG="$REPO_ROOT/scripts/modules/terminals/ghostty/assets/config"
REPO_GHOSTTY_LOCAL_CONFIG="$REPO_ROOT/scripts/modules/terminals/ghostty/assets/local.conf"
TARGET_GHOSTTY_DIR="$HOME/.config/ghostty"
TARGET_GHOSTTY_CONFIG="$TARGET_GHOSTTY_DIR/config"
TARGET_GHOSTTY_LOCAL_CONFIG="$TARGET_GHOSTTY_DIR/local.conf"

find_ghostty_app() {
  local candidate

  for candidate in \
    "/Applications/Ghostty.app" \
    "$HOME/Applications/Ghostty.app"; do
    if [[ -d "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

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

install_app() {
  local app_path=""

  if app_path="$(find_ghostty_app 2>/dev/null)"; then
    log_warn "Ghostty already exists at $app_path. Leaving the existing app in place."
    return 0
  fi

  brew_install_cask "ghostty"

  if brew list --cask "ghostty" >/dev/null 2>&1; then
    app_path="$(find_ghostty_app 2>/dev/null || true)"
    if [[ -z "$app_path" ]]; then
      log_warn "Homebrew reports ghostty is installed, but the app bundle was not found in a standard Applications directory."
      log_info "Reinstalling Ghostty cask to restore the app bundle..."
      brew reinstall --cask "ghostty"
    fi
  fi
}

install_config() {
  [[ -f "$REPO_GHOSTTY_CONFIG" ]] || die "Missing repo-managed Ghostty config: $REPO_GHOSTTY_CONFIG"
  [[ -f "$REPO_GHOSTTY_LOCAL_CONFIG" ]] || die "Missing repo-managed Ghostty local config template: $REPO_GHOSTTY_LOCAL_CONFIG"
  mkdir -p "$TARGET_GHOSTTY_DIR"
  backup_if_unmanaged "$TARGET_GHOSTTY_CONFIG" "$TARGET_GHOSTTY_CONFIG.pre-mac-dev-setup.bak"
  cp "$REPO_GHOSTTY_CONFIG" "$TARGET_GHOSTTY_CONFIG"
  copy_repo_file_if_missing "$REPO_GHOSTTY_LOCAL_CONFIG" "$TARGET_GHOSTTY_LOCAL_CONFIG"
}

verify_install() {
  local app_path=""

  app_path="$(find_ghostty_app 2>/dev/null || true)"
  [[ -n "$app_path" ]] || die "Ghostty app not found in /Applications or ~/Applications after installation."
  [[ -f "$TARGET_GHOSTTY_CONFIG" ]] || die "Ghostty config not found at $TARGET_GHOSTTY_CONFIG after installation."
  [[ -f "$TARGET_GHOSTTY_LOCAL_CONFIG" ]] || die "Ghostty local config not found at $TARGET_GHOSTTY_LOCAL_CONFIG after installation."
  grep -Fq "font-family = JetBrainsMono Nerd Font" "$TARGET_GHOSTTY_CONFIG" || die "Ghostty config does not set JetBrainsMono Nerd Font."
  grep -Fq "config-file = ?local.conf" "$TARGET_GHOSTTY_CONFIG" || die "Ghostty config does not include local override support."

  log_info "Ghostty app verified at $app_path"
}

main() {
  install_app
  install_config
  verify_install

  log_success "Ghostty installation verified."
}

main "$@"
