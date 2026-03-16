#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_JAVA_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/java/java-neovim.lua"
TARGET_JAVA_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_java.lua"
REPO_JAVA_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/java/java-vscode-extensions.txt"
TARGET_JAVA_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/java-vscode-extensions.txt"
REPO_JAVA_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/java/java-vscode-settings.jsonc"
TARGET_JAVA_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/java-vscode-settings.jsonc"

install_java_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_JAVA_NVIM_PLUGIN" "$(basename "$TARGET_JAVA_NVIM_PLUGIN")" >/dev/null
}

install_java_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_JAVA_VSCODE_EXTENSIONS" "$(basename "$TARGET_JAVA_VSCODE_EXTENSIONS")" >/dev/null
}

install_java_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_JAVA_VSCODE_SETTINGS" "$(basename "$TARGET_JAVA_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_formula "jdtls"
  brew_install_formula "google-java-format"

  command_exists jdtls || die "jdtls command not found after installation."
  command_exists google-java-format || die "google-java-format command not found after installation."

  log_info "Java tooling versions:"
  jdtls --version
  google-java-format --version
  install_java_vscode_extensions
  install_java_vscode_settings
  install_java_neovim_plugin
  [[ -f "$TARGET_JAVA_VSCODE_EXTENSIONS" ]] || die "Java VS Code extensions manifest not found at $TARGET_JAVA_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_JAVA_VSCODE_SETTINGS" ]] || die "Java VS Code settings fragment not found at $TARGET_JAVA_VSCODE_SETTINGS"
  [[ -f "$TARGET_JAVA_NVIM_PLUGIN" ]] || die "Java Neovim plugin spec not found at $TARGET_JAVA_NVIM_PLUGIN"

  log_success "Java tooling installation verified."
}

main "$@"
