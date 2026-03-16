#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_TERRAFORM_HCL_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/terraform-hcl/terraform-hcl-neovim.lua"
TARGET_TERRAFORM_HCL_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_terraform_hcl.lua"
REPO_TERRAFORM_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/specs/terraform-hcl/terraform-completion.zsh"
TARGET_TERRAFORM_ZSH_PLUGIN="$HOME/.zsh/plugins/terraform-completion.zsh"
REPO_TERRAFORM_HCL_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/specs/terraform-hcl/terraform-hcl-vscode-extensions.txt"
TARGET_TERRAFORM_HCL_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/terraform-hcl-vscode-extensions.txt"
REPO_TERRAFORM_HCL_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/specs/terraform-hcl/terraform-hcl-vscode-settings.jsonc"
TARGET_TERRAFORM_HCL_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/terraform-hcl-vscode-settings.jsonc"

install_terraform_hcl_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_TERRAFORM_HCL_NVIM_PLUGIN" "$(basename "$TARGET_TERRAFORM_HCL_NVIM_PLUGIN")" >/dev/null
}

install_terraform_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_TERRAFORM_ZSH_PLUGIN" "$(basename "$TARGET_TERRAFORM_ZSH_PLUGIN")" >/dev/null
}

install_terraform_hcl_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_TERRAFORM_HCL_VSCODE_EXTENSIONS" "$(basename "$TARGET_TERRAFORM_HCL_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_TERRAFORM_HCL_VSCODE_SETTINGS" "$(basename "$TARGET_TERRAFORM_HCL_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_and_verify_command "terraform" "terraform" "Terraform" version
  brew_install_and_verify_command "tflint" "tflint" "tflint" --version
  brew_install_and_verify_command "terraform-ls" "terraform-ls" "Terraform language server" version
  install_terraform_zsh_plugin
  install_terraform_hcl_vscode_assets
  install_terraform_hcl_neovim_plugin
  [[ -f "$TARGET_TERRAFORM_ZSH_PLUGIN" ]] || die "Terraform zsh completion plugin not found at $TARGET_TERRAFORM_ZSH_PLUGIN"
  [[ -f "$TARGET_TERRAFORM_HCL_VSCODE_EXTENSIONS" ]] || die "Terraform/HCL VS Code extensions manifest not found at $TARGET_TERRAFORM_HCL_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_TERRAFORM_HCL_VSCODE_SETTINGS" ]] || die "Terraform/HCL VS Code settings fragment not found at $TARGET_TERRAFORM_HCL_VSCODE_SETTINGS"
  [[ -f "$TARGET_TERRAFORM_HCL_NVIM_PLUGIN" ]] || die "Terraform/HCL Neovim plugin spec not found at $TARGET_TERRAFORM_HCL_NVIM_PLUGIN"
}

main "$@"
