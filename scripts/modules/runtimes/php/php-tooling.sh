#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_PHP_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/php/php-neovim.lua"
TARGET_PHP_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_php.lua"
REPO_PHP_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/php/php-vscode-extensions.txt"
TARGET_PHP_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/php-vscode-extensions.txt"
REPO_PHP_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/php/php-vscode-settings.jsonc"
TARGET_PHP_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/php-vscode-settings.jsonc"

install_php_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_PHP_NVIM_PLUGIN" "$(basename "$TARGET_PHP_NVIM_PLUGIN")" >/dev/null
}

install_php_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_PHP_VSCODE_EXTENSIONS" "$(basename "$TARGET_PHP_VSCODE_EXTENSIONS")" >/dev/null
}

install_php_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_PHP_VSCODE_SETTINGS" "$(basename "$TARGET_PHP_VSCODE_SETTINGS")" >/dev/null
}

main() {
  local phpactor_dir="$HOME/.local/bin"
  local phpactor_bin="$phpactor_dir/phpactor"
  local tmp_phpactor

  brew_install_formula "composer"
  brew_install_formula "phpstan"
  brew_install_formula "php-cs-fixer"
  ensure_local_bin_in_path

  tmp_phpactor="$(mktemp "${TMPDIR:-/tmp}/phpactor.XXXXXX")"
  trap 'rm -f "$tmp_phpactor"' EXIT
  curl -fsSL -o "$tmp_phpactor" "https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar"
  chmod +x "$tmp_phpactor"
  mkdir -p "$phpactor_dir"
  mv "$tmp_phpactor" "$phpactor_bin"
  trap - EXIT

  command_exists composer || die "composer command not found after installation."
  command_exists phpstan || die "phpstan command not found after installation."
  command_exists php-cs-fixer || die "php-cs-fixer command not found after installation."
  command_exists_in_zsh phpactor || die "phpactor command not found in zsh after installation."

  log_info "Verifying PHP tooling..."
  composer --version
  phpstan --version
  php-cs-fixer --version
  run_in_login_zsh 'phpactor --version'
  run_in_login_zsh 'phpactor language-server --help >/dev/null'
  install_php_vscode_extensions
  install_php_vscode_settings
  install_php_neovim_plugin
  [[ -f "$TARGET_PHP_VSCODE_EXTENSIONS" ]] || die "PHP VS Code extensions manifest not found at $TARGET_PHP_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_PHP_VSCODE_SETTINGS" ]] || die "PHP VS Code settings fragment not found at $TARGET_PHP_VSCODE_SETTINGS"
  [[ -f "$TARGET_PHP_NVIM_PLUGIN" ]] || die "PHP Neovim plugin spec not found at $TARGET_PHP_NVIM_PLUGIN"

  log_success "PHP tooling verified."
}

main "$@"
