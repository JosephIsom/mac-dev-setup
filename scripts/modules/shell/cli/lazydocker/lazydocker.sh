#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_LAZYDOCKER_CONFIG="$REPO_ROOT/scripts/modules/shell/cli/lazydocker/assets/config.yml"
TARGET_LAZYDOCKER_CONFIG_DIR="$HOME/.config/lazydocker"
TARGET_LAZYDOCKER_CONFIG="$TARGET_LAZYDOCKER_CONFIG_DIR/config.yml"

install_lazydocker_config() {
  [[ -f "$REPO_LAZYDOCKER_CONFIG" ]] || die "Missing repo-managed lazydocker config: $REPO_LAZYDOCKER_CONFIG"
  mkdir -p "$TARGET_LAZYDOCKER_CONFIG_DIR"
  cp "$REPO_LAZYDOCKER_CONFIG" "$TARGET_LAZYDOCKER_CONFIG"
}

main() {
  brew_install_and_verify_command "lazydocker" "lazydocker" "lazydocker" --version
  install_lazydocker_config
  [[ -f "$TARGET_LAZYDOCKER_CONFIG" ]] || die "lazydocker config not found at $TARGET_LAZYDOCKER_CONFIG"
}

main "$@"
