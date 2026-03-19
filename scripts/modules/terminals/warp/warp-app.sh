#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Warp.app"
TARGET_WARP_DIR="$HOME/.warp"
TARGET_WARP_NOTES="$TARGET_WARP_DIR/bootstrap-notes.txt"

install_app() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Warp already exists at $APP_PATH. Leaving the existing app in place."
    return 0
  fi

  brew_install_cask "warp"
}

write_notes() {
  mkdir -p "$TARGET_WARP_DIR"

  cat > "$TARGET_WARP_NOTES" <<EOF
Warp bootstrap notes

In Warp:
1. Open Settings > Appearance > Current Theme
2. Pick any built-in theme you prefer
3. Open Settings > Appearance > Text
4. Set font to "JetBrainsMono Nerd Font"
5. Set font size to 14

Warp does not currently expose a reliable file-based automatic theme switcher for macOS light/dark mode.
If you change system appearance later, adjust the theme manually in-app if needed.
EOF
}

verify_install() {
  [[ -d "$APP_PATH" ]] || die "Warp app not found at $APP_PATH after installation."
  [[ -f "$TARGET_WARP_NOTES" ]] || die "Warp bootstrap notes not found at $TARGET_WARP_NOTES after installation."
  grep -Fq "JetBrainsMono Nerd Font" "$TARGET_WARP_NOTES" || die "Warp bootstrap notes do not mention the managed font."
}

main() {
  install_app
  write_notes
  verify_install

  log_success "Warp installation verified."
  log_warn "Warp does not currently expose an official file-based settings path for selecting the active light/dark theme automatically."
  log_warn "Use $TARGET_WARP_NOTES to finish the one-time in-app theme and font selection."
}

main "$@"
