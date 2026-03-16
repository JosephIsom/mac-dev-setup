#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_RUST_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/rust/rust-neovim.lua"
TARGET_RUST_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_rust.lua"
REPO_RUST_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/rust/rust-vscode-extensions.txt"
TARGET_RUST_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/rust-vscode-extensions.txt"
REPO_RUST_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/rust/rust-vscode-settings.jsonc"
TARGET_RUST_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/rust-vscode-settings.jsonc"

install_rust_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_RUST_NVIM_PLUGIN" "$(basename "$TARGET_RUST_NVIM_PLUGIN")" >/dev/null
}

install_rust_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_RUST_VSCODE_EXTENSIONS" "$(basename "$TARGET_RUST_VSCODE_EXTENSIONS")" >/dev/null
}

install_rust_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_RUST_VSCODE_SETTINGS" "$(basename "$TARGET_RUST_VSCODE_SETTINGS")" >/dev/null
}

main() {
  if command_exists_in_zsh rustup; then
    log_info "Installing Rust tooling components..."
    run_in_login_zsh 'rustup component add rust-src rust-analyzer rustfmt clippy'
  fi

  cargo_install_global_crate 'cargo-audit'
  cargo_install_global_crate 'cargo-nextest'
  cargo_install_global_crate 'bacon'

  log_info "Verifying Rust tooling..."
  run_in_login_zsh 'rust-analyzer --version'
  run_in_login_zsh 'rustfmt --version'
  run_in_login_zsh 'cargo clippy --version'
  run_in_login_zsh 'cargo-audit --version'
  run_in_login_zsh 'cargo-nextest --version'
  run_in_login_zsh 'bacon --version'
  install_rust_vscode_extensions
  install_rust_vscode_settings
  install_rust_neovim_plugin
  [[ -f "$TARGET_RUST_VSCODE_EXTENSIONS" ]] || die "Rust VS Code extensions manifest not found at $TARGET_RUST_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_RUST_VSCODE_SETTINGS" ]] || die "Rust VS Code settings fragment not found at $TARGET_RUST_VSCODE_SETTINGS"
  [[ -f "$TARGET_RUST_NVIM_PLUGIN" ]] || die "Rust Neovim plugin spec not found at $TARGET_RUST_NVIM_PLUGIN"

  log_success "Rust tooling installation verified."
}

main "$@"
