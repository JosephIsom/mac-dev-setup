#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_BOTTOM_CONFIG="$REPO_ROOT/scripts/modules/shell/cli/bottom/assets/bottom.toml"
TARGET_BOTTOM_CONFIG_DIR="$HOME/.config/bottom"
TARGET_BOTTOM_CONFIG="$TARGET_BOTTOM_CONFIG_DIR/bottom.toml"

install_bottom_config() {
  [[ -f "$REPO_BOTTOM_CONFIG" ]] || die "Missing repo-managed bottom config: $REPO_BOTTOM_CONFIG"
  mkdir -p "$TARGET_BOTTOM_CONFIG_DIR"
  cp "$REPO_BOTTOM_CONFIG" "$TARGET_BOTTOM_CONFIG"
}

main() {
  brew_install_and_verify_command "bottom" "btm" "bottom" --version
  install_bottom_config
  [[ -f "$TARGET_BOTTOM_CONFIG" ]] || die "bottom config not found at $TARGET_BOTTOM_CONFIG"
}

main "$@"
