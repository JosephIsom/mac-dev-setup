#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DOCKERFILE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/dockerfile/dockerfile-neovim.lua"
TARGET_DOCKERFILE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_dockerfile.lua"

install_dockerfile_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_DOCKERFILE_NVIM_PLUGIN" "$(basename "$TARGET_DOCKERFILE_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "hadolint"
  brew_install_formula "dockerfile-language-server"

  command_exists hadolint || die "hadolint command not found after installation."
  command_exists docker-langserver || die "docker-langserver command not found after installation."

  log_info "Verifying Dockerfile tooling..."
  hadolint --version
  docker-langserver --version
  install_dockerfile_neovim_plugin
  [[ -f "$TARGET_DOCKERFILE_NVIM_PLUGIN" ]] || die "Dockerfile Neovim plugin spec not found at $TARGET_DOCKERFILE_NVIM_PLUGIN"
}

main "$@"
