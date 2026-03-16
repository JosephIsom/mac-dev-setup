#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_VUE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/vue/vue-neovim.lua"
TARGET_VUE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_vue.lua"
REPO_VUE_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/vue/vue-vscode-extensions.txt"
TARGET_VUE_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/vue-vscode-extensions.txt"
REPO_VUE_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/vue/vue-vscode-settings.jsonc"
TARGET_VUE_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/vue-vscode-settings.jsonc"

install_vue_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_VUE_NVIM_PLUGIN" "$(basename "$TARGET_VUE_NVIM_PLUGIN")" >/dev/null
}

install_vue_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_VUE_VSCODE_EXTENSIONS" "$(basename "$TARGET_VUE_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_VUE_VSCODE_SETTINGS" "$(basename "$TARGET_VUE_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package '@vue/language-server@latest'
  npm_install_global_package 'vue-tsc@latest'

  log_info "Verifying Vue tooling..."
  run_in_login_zsh 'command -v vue-language-server >/dev/null 2>&1'
  run_in_login_zsh 'vue-tsc --version'
  install_vue_vscode_assets
  install_vue_neovim_plugin
  [[ -f "$TARGET_VUE_VSCODE_EXTENSIONS" ]] || die "Vue VS Code extensions manifest not found at $TARGET_VUE_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_VUE_VSCODE_SETTINGS" ]] || die "Vue VS Code settings fragment not found at $TARGET_VUE_VSCODE_SETTINGS"
  [[ -f "$TARGET_VUE_NVIM_PLUGIN" ]] || die "Vue Neovim plugin spec not found at $TARGET_VUE_NVIM_PLUGIN"

  log_success "Vue tooling installation verified."
}

main "$@"
