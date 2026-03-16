#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_KIND_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/containers/kind/kind-vscode-extensions.txt"
TARGET_KIND_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/kind-vscode-extensions.txt"

install_kind_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_KIND_VSCODE_EXTENSIONS" "$(basename "$TARGET_KIND_VSCODE_EXTENSIONS")" >/dev/null
}

main() {
  brew_install_and_verify_command "kind" "kind" "kind" version
  install_kind_vscode_extensions
  [[ -f "$TARGET_KIND_VSCODE_EXTENSIONS" ]] || die "kind VS Code extensions manifest not found at $TARGET_KIND_VSCODE_EXTENSIONS"
}

main "$@"
