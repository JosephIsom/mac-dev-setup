#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ANSIBLE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/ansible/ansible-neovim.lua"
TARGET_ANSIBLE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_ansible.lua"

install_ansible_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_ANSIBLE_NVIM_PLUGIN" "$(basename "$TARGET_ANSIBLE_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "ansible"
  brew_install_formula "ansible-lint"

  command_exists ansible-playbook || die "ansible-playbook command not found after installation."
  command_exists ansible-lint || die "ansible-lint command not found after installation."

  log_info "Verifying Ansible tooling..."
  ansible-playbook --version
  ansible-lint --version
  install_ansible_neovim_plugin
  [[ -f "$TARGET_ANSIBLE_NVIM_PLUGIN" ]] || die "Ansible Neovim plugin spec not found at $TARGET_ANSIBLE_NVIM_PLUGIN"

  log_success "Ansible tooling installation verified."
}

main "$@"
