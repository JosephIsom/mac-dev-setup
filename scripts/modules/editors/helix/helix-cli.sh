#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_HELIX_CONFIG="$REPO_ROOT/scripts/modules/editors/helix/assets/config.toml"
REPO_HELIX_THEME="$REPO_ROOT/scripts/modules/editors/helix/assets/themes/islands_dark.toml"
TARGET_HELIX_DIR="$HOME/.config/helix"
TARGET_HELIX_CONFIG="$TARGET_HELIX_DIR/config.toml"
TARGET_HELIX_THEME_DIR="$TARGET_HELIX_DIR/themes"
TARGET_HELIX_THEME="$TARGET_HELIX_THEME_DIR/islands_dark.toml"

install_config() {
  [[ -f "$REPO_HELIX_CONFIG" ]] || die "Missing repo-managed Helix config: $REPO_HELIX_CONFIG"
  [[ -f "$REPO_HELIX_THEME" ]] || die "Missing repo-managed Helix theme: $REPO_HELIX_THEME"

  mkdir -p "$TARGET_HELIX_THEME_DIR"
  cp "$REPO_HELIX_CONFIG" "$TARGET_HELIX_CONFIG"
  cp "$REPO_HELIX_THEME" "$TARGET_HELIX_THEME"
}

main() {
  brew_install_and_verify_command "helix" "hx" "Helix editor" --version
  install_config
  [[ -f "$TARGET_HELIX_CONFIG" ]] || die "Helix config not found at $TARGET_HELIX_CONFIG"
  [[ -f "$TARGET_HELIX_THEME" ]] || die "Helix theme not found at $TARGET_HELIX_THEME"
}

main "$@"
