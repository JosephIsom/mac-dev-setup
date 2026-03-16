#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Warp.app"
REPO_WARP_THEME_DIR="$REPO_ROOT/scripts/modules/terminals/warp/assets"
TARGET_WARP_DIR="$HOME/.warp"
TARGET_WARP_THEME_DIR="$TARGET_WARP_DIR/themes"
TARGET_WARP_NOTES="$TARGET_WARP_DIR/bootstrap-notes.txt"

install_app() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Warp already exists at $APP_PATH. Leaving the existing app in place."
    return 0
  fi

  brew_install_cask "warp"
}

install_theme() {
  [[ -d "$REPO_WARP_THEME_DIR" ]] || die "Missing repo-managed Warp theme directory: $REPO_WARP_THEME_DIR"

  mkdir -p "$TARGET_WARP_THEME_DIR"
  find "$REPO_WARP_THEME_DIR" -type f -name 'apple-graphite-expanded-*-mac-dev-setup.yaml' -exec cp {} "$TARGET_WARP_THEME_DIR/" \;
}

write_notes() {
  mkdir -p "$TARGET_WARP_DIR"

  cat > "$TARGET_WARP_NOTES" <<EOF
Warp bootstrap notes

Installed custom themes:
  $TARGET_WARP_THEME_DIR/apple-graphite-expanded-dark-mac-dev-setup.yaml
  $TARGET_WARP_THEME_DIR/apple-graphite-expanded-light-mac-dev-setup.yaml

In Warp:
1. Open Settings > Appearance > Current Theme
2. Pick the theme that matches your current macOS appearance:
   - Apple Graphite Expanded Dark (mac-dev-setup)
   - Apple Graphite Expanded Light (mac-dev-setup)
3. Open Settings > Appearance > Text
4. Set font to "JetBrainsMono Nerd Font"
5. Set font size to 14

Warp does not currently expose a reliable file-based automatic theme switcher for macOS light/dark mode.
If you change system appearance later, switch the Warp theme manually to the matching variant.
EOF
}

verify_install() {
  [[ -d "$APP_PATH" ]] || die "Warp app not found at $APP_PATH after installation."
  [[ -f "$TARGET_WARP_THEME_DIR/apple-graphite-expanded-dark-mac-dev-setup.yaml" ]] || die "Warp dark theme not found after installation."
  [[ -f "$TARGET_WARP_THEME_DIR/apple-graphite-expanded-light-mac-dev-setup.yaml" ]] || die "Warp light theme not found after installation."
  [[ -f "$TARGET_WARP_NOTES" ]] || die "Warp bootstrap notes not found at $TARGET_WARP_NOTES after installation."
  grep -Fq 'name: Apple Graphite Expanded Dark (mac-dev-setup)' "$TARGET_WARP_THEME_DIR/apple-graphite-expanded-dark-mac-dev-setup.yaml" || die "Warp dark theme file is missing the managed theme name."
  grep -Fq 'name: Apple Graphite Expanded Light (mac-dev-setup)' "$TARGET_WARP_THEME_DIR/apple-graphite-expanded-light-mac-dev-setup.yaml" || die "Warp light theme file is missing the managed theme name."
  grep -Fq "JetBrainsMono Nerd Font" "$TARGET_WARP_NOTES" || die "Warp bootstrap notes do not mention the managed font."
}

main() {
  install_app
  install_theme
  write_notes
  verify_install

  log_success "Warp installation verified."
  log_warn "Warp does not currently expose an official file-based settings path for selecting the active light/dark theme automatically."
  log_warn "Use $TARGET_WARP_NOTES to finish the one-time in-app theme and font selection."
}

main "$@"
