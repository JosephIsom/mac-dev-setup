#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_C_CPP_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/languages/c-cpp/c-cpp-llvm-path.zsh"
TARGET_C_CPP_ZSH_PLUGIN="$HOME/.zsh/plugins/c-cpp-llvm-path.zsh"
REPO_C_CPP_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/c-cpp/c-cpp-neovim.lua"
TARGET_C_CPP_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_c_cpp.lua"
REPO_C_CPP_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/c-cpp/c-cpp-vscode-extensions.txt"
TARGET_C_CPP_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/c-cpp-vscode-extensions.txt"
REPO_C_CPP_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/c-cpp/c-cpp-vscode-settings.jsonc"
TARGET_C_CPP_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/c-cpp-vscode-settings.jsonc"

install_c_cpp_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_C_CPP_ZSH_PLUGIN" "$(basename "$TARGET_C_CPP_ZSH_PLUGIN")" >/dev/null
}

install_c_cpp_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_C_CPP_NVIM_PLUGIN" "$(basename "$TARGET_C_CPP_NVIM_PLUGIN")" >/dev/null
}

install_c_cpp_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_C_CPP_VSCODE_EXTENSIONS" "$(basename "$TARGET_C_CPP_VSCODE_EXTENSIONS")" >/dev/null
}

install_c_cpp_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_C_CPP_VSCODE_SETTINGS" "$(basename "$TARGET_C_CPP_VSCODE_SETTINGS")" >/dev/null
}

main() {
  run_script_path "$PREREQUISITES_DIR/xcode/xcode-clt.sh"

  brew_install_formula "cmake"
  brew_install_formula "ninja"
  brew_install_formula "llvm"

  install_c_cpp_zsh_plugin

  run_in_login_zsh 'xcrun --find clang >/dev/null 2>&1'
  run_in_login_zsh 'xcrun --find clang++ >/dev/null 2>&1'
  run_in_login_zsh 'xcrun --find lldb >/dev/null 2>&1'
  run_in_login_zsh 'command -v cmake >/dev/null 2>&1'
  run_in_login_zsh 'command -v ninja >/dev/null 2>&1'
  run_in_login_zsh 'command -v clangd >/dev/null 2>&1'
  run_in_login_zsh 'command -v clang-format >/dev/null 2>&1'
  run_in_login_zsh 'command -v clang-tidy >/dev/null 2>&1'

  log_info "Verifying C/C++ tooling in zsh..."
  run_in_login_zsh 'xcrun clang --version | head -n 1'
  run_in_login_zsh 'xcrun clang++ --version | head -n 1'
  run_in_login_zsh 'xcrun lldb --version | head -n 1'
  run_in_login_zsh 'clangd --version | head -n 1'
  run_in_login_zsh 'clang-format --version'
  run_in_login_zsh 'clang-tidy --version | head -n 1'
  run_in_login_zsh 'cmake --version | head -n 1'
  run_in_login_zsh 'ninja --version'

  install_c_cpp_vscode_extensions
  install_c_cpp_vscode_settings
  install_c_cpp_neovim_plugin

  [[ -f "$TARGET_C_CPP_ZSH_PLUGIN" ]] || die "C/C++ llvm path plugin not found at $TARGET_C_CPP_ZSH_PLUGIN"
  [[ -f "$TARGET_C_CPP_VSCODE_EXTENSIONS" ]] || die "C/C++ VS Code extensions manifest not found at $TARGET_C_CPP_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_C_CPP_VSCODE_SETTINGS" ]] || die "C/C++ VS Code settings fragment not found at $TARGET_C_CPP_VSCODE_SETTINGS"
  [[ -f "$TARGET_C_CPP_NVIM_PLUGIN" ]] || die "C/C++ Neovim plugin spec not found at $TARGET_C_CPP_NVIM_PLUGIN"

  log_success "C/C++ tooling installation verified."
}

main "$@"
