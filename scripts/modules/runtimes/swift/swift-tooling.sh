#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SWIFT_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/swift/swift-neovim.lua"
TARGET_SWIFT_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_swift.lua"
REPO_SWIFT_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/swift/swift-vscode-extensions.txt"
TARGET_SWIFT_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/swift-vscode-extensions.txt"
REPO_SWIFT_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/swift/swift-vscode-settings.jsonc"
TARGET_SWIFT_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/swift-vscode-settings.jsonc"

install_swift_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_SWIFT_NVIM_PLUGIN" "$(basename "$TARGET_SWIFT_NVIM_PLUGIN")" >/dev/null
}

install_swift_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_SWIFT_VSCODE_EXTENSIONS" "$(basename "$TARGET_SWIFT_VSCODE_EXTENSIONS")" >/dev/null
}

install_swift_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_SWIFT_VSCODE_SETTINGS" "$(basename "$TARGET_SWIFT_VSCODE_SETTINGS")" >/dev/null
}

main() {
  command_exists swift || die "swift command not found. Xcode Command Line Tools are required."

  brew_install_formula "swiftlint"
  brew_install_formula "swiftformat"

  command_exists swiftlint || die "swiftlint command not found after installation."
  command_exists swiftformat || die "swiftformat command not found after installation."

  log_info "Swift toolchain and tooling versions:"
  swift --version
  swiftlint version
  swiftformat --version
  xcrun sourcekit-lsp --help >/dev/null
  install_swift_vscode_extensions
  install_swift_vscode_settings
  install_swift_neovim_plugin
  [[ -f "$TARGET_SWIFT_VSCODE_EXTENSIONS" ]] || die "Swift VS Code extensions manifest not found at $TARGET_SWIFT_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_SWIFT_VSCODE_SETTINGS" ]] || die "Swift VS Code settings fragment not found at $TARGET_SWIFT_VSCODE_SETTINGS"
  [[ -f "$TARGET_SWIFT_NVIM_PLUGIN" ]] || die "Swift Neovim plugin spec not found at $TARGET_SWIFT_NVIM_PLUGIN"

  log_success "Swift tooling installation verified."
}

main "$@"
