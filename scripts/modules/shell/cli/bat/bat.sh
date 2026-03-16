#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_BAT_CONFIG="$REPO_ROOT/scripts/modules/shell/cli/bat/assets/config"
TARGET_BAT_CONFIG_DIR="$HOME/.config/bat"
TARGET_BAT_CONFIG="$TARGET_BAT_CONFIG_DIR/config"

install_bat_config() {
  [[ -f "$REPO_BAT_CONFIG" ]] || die "Missing repo-managed bat config: $REPO_BAT_CONFIG"
  mkdir -p "$TARGET_BAT_CONFIG_DIR"
  cp "$REPO_BAT_CONFIG" "$TARGET_BAT_CONFIG"
}

main() {
  brew_install_and_verify_command "bat" "bat" "bat" --version
  install_bat_config
}

main "$@"
