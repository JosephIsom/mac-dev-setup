#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SVELTE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/svelte/svelte-neovim.lua"
TARGET_SVELTE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_svelte.lua"
REPO_SVELTE_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/svelte/svelte-vscode-extensions.txt"
TARGET_SVELTE_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/svelte-vscode-extensions.txt"
REPO_SVELTE_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/svelte/svelte-vscode-settings.jsonc"
TARGET_SVELTE_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/svelte-vscode-settings.jsonc"

install_svelte_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_SVELTE_NVIM_PLUGIN" "$(basename "$TARGET_SVELTE_NVIM_PLUGIN")" >/dev/null
}

install_svelte_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_SVELTE_VSCODE_EXTENSIONS" "$(basename "$TARGET_SVELTE_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_SVELTE_VSCODE_SETTINGS" "$(basename "$TARGET_SVELTE_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package 'svelte-language-server@latest'

  log_info "Verifying Svelte tooling..."
  run_in_login_zsh 'svelteserver --version >/dev/null 2>&1 || command -v svelte-language-server >/dev/null 2>&1'
  install_svelte_vscode_assets
  install_svelte_neovim_plugin
  [[ -f "$TARGET_SVELTE_VSCODE_EXTENSIONS" ]] || die "Svelte VS Code extensions manifest not found at $TARGET_SVELTE_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_SVELTE_VSCODE_SETTINGS" ]] || die "Svelte VS Code settings fragment not found at $TARGET_SVELTE_VSCODE_SETTINGS"
  [[ -f "$TARGET_SVELTE_NVIM_PLUGIN" ]] || die "Svelte Neovim plugin spec not found at $TARGET_SVELTE_NVIM_PLUGIN"

  log_success "Svelte tooling installation verified."
}

main "$@"
