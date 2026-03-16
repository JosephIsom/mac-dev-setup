#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_KOTLIN_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/kotlin/kotlin-neovim.lua"
TARGET_KOTLIN_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_kotlin.lua"
REPO_KOTLIN_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/kotlin/kotlin-vscode-extensions.txt"
TARGET_KOTLIN_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/kotlin-vscode-extensions.txt"
REPO_KOTLIN_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/kotlin/kotlin-vscode-settings.jsonc"
TARGET_KOTLIN_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/kotlin-vscode-settings.jsonc"

install_kotlin_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_KOTLIN_NVIM_PLUGIN" "$(basename "$TARGET_KOTLIN_NVIM_PLUGIN")" >/dev/null
}

install_kotlin_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_KOTLIN_VSCODE_EXTENSIONS" "$(basename "$TARGET_KOTLIN_VSCODE_EXTENSIONS")" >/dev/null
}

install_kotlin_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_KOTLIN_VSCODE_SETTINGS" "$(basename "$TARGET_KOTLIN_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_formula "kotlin-language-server"
  brew_install_formula "ktfmt"
  brew_install_formula "detekt"

  command_exists kotlin-language-server || die "kotlin-language-server command not found after installation."
  command_exists ktfmt || die "ktfmt command not found after installation."
  command_exists detekt || die "detekt command not found after installation."

  log_info "Verifying Kotlin tooling..."
  kotlin-language-server --version
  ktfmt --version
  detekt --version
  install_kotlin_vscode_extensions
  install_kotlin_vscode_settings
  install_kotlin_neovim_plugin
  [[ -f "$TARGET_KOTLIN_VSCODE_EXTENSIONS" ]] || die "Kotlin VS Code extensions manifest not found at $TARGET_KOTLIN_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_KOTLIN_VSCODE_SETTINGS" ]] || die "Kotlin VS Code settings fragment not found at $TARGET_KOTLIN_VSCODE_SETTINGS"
  [[ -f "$TARGET_KOTLIN_NVIM_PLUGIN" ]] || die "Kotlin Neovim plugin spec not found at $TARGET_KOTLIN_NVIM_PLUGIN"

  log_success "Kotlin tooling verified."
}

main "$@"
