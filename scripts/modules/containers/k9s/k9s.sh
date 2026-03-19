#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_K9S_CONFIG="$REPO_ROOT/scripts/modules/containers/k9s/assets/config.yaml"
REPO_K9S_SKIN="$REPO_ROOT/scripts/modules/containers/k9s/assets/skins/islands-dark.yaml"
TARGET_K9S_DIR="$HOME/Library/Application Support/k9s"
TARGET_K9S_SKIN_DIR="$TARGET_K9S_DIR/skins"
TARGET_K9S_CONFIG="$TARGET_K9S_DIR/config.yaml"
TARGET_K9S_SKIN="$TARGET_K9S_SKIN_DIR/islands-dark.yaml"

install_k9s_theme() {
  [[ -f "$REPO_K9S_CONFIG" ]] || die "Missing repo-managed k9s config: $REPO_K9S_CONFIG"
  [[ -f "$REPO_K9S_SKIN" ]] || die "Missing repo-managed k9s skin: $REPO_K9S_SKIN"

  mkdir -p "$TARGET_K9S_SKIN_DIR"
  cp "$REPO_K9S_CONFIG" "$TARGET_K9S_CONFIG"
  cp "$REPO_K9S_SKIN" "$TARGET_K9S_SKIN"
}

main() {
  brew_install_and_verify_command "k9s" "k9s" "k9s" version
  install_k9s_theme
  [[ -f "$TARGET_K9S_CONFIG" ]] || die "k9s config not found at $TARGET_K9S_CONFIG"
  [[ -f "$TARGET_K9S_SKIN" ]] || die "k9s skin not found at $TARGET_K9S_SKIN"
}

main "$@"
