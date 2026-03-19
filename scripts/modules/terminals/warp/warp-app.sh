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
  find "$REPO_WARP_THEME_DIR" -type f -name 'islands-dark-mac-dev-setup.yaml' -exec cp {} "$TARGET_WARP_THEME_DIR/" \;
}

write_notes() {
  mkdir -p "$TARGET_WARP_DIR"

  cat > "$TARGET_WARP_NOTES" <<EOF
Warp bootstrap notes

Installed custom theme:
  $TARGET_WARP_THEME_DIR/islands-dark-mac-dev-setup.yaml

In Warp:
1. Open Settings > Appearance > Current Theme
2. Pick:
   - Islands Dark (mac-dev-setup)
3. Open Settings > Appearance > Text
4. Set font to "JetBrainsMono Nerd Font"
5. Set font size to 14

Warp is pinned to a single dark theme for consistency across the rest of the repo-managed tooling.
EOF
}

verify_install() {
  [[ -d "$APP_PATH" ]] || die "Warp app not found at $APP_PATH after installation."
  [[ -f "$TARGET_WARP_THEME_DIR/islands-dark-mac-dev-setup.yaml" ]] || die "Warp theme not found after installation."
  [[ -f "$TARGET_WARP_NOTES" ]] || die "Warp bootstrap notes not found at $TARGET_WARP_NOTES after installation."
  grep -Fq 'name: Islands Dark (mac-dev-setup)' "$TARGET_WARP_THEME_DIR/islands-dark-mac-dev-setup.yaml" || die "Warp theme file is missing the managed theme name."
  grep -Fq "JetBrainsMono Nerd Font" "$TARGET_WARP_NOTES" || die "Warp bootstrap notes do not mention the managed font."
}

main() {
  install_app
  install_theme
  write_notes
  verify_install

  log_success "Warp installation verified."
  log_warn "Use $TARGET_WARP_NOTES to finish the one-time in-app theme and font selection."
}

main "$@"
