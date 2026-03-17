#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_COMPOSE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/compose/compose-neovim.lua"
TARGET_COMPOSE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_compose.lua"

install_compose_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_COMPOSE_NVIM_PLUGIN" "$(basename "$TARGET_COMPOSE_NVIM_PLUGIN")" >/dev/null
}

main() {
  command_exists docker || die "docker command must be available before Compose support runs."

  brew_install_formula "docker-compose-langserver"

  command_exists docker-compose-langserver || die "docker-compose-langserver command not found after installation."

  log_info "Verifying Docker Compose authoring support..."
  docker compose version
  log_info "docker-compose-langserver available: $(command -v docker-compose-langserver)"
  install_compose_neovim_plugin
  [[ -f "$TARGET_COMPOSE_NVIM_PLUGIN" ]] || die "Compose Neovim plugin spec not found at $TARGET_COMPOSE_NVIM_PLUGIN"

  log_success "Docker Compose authoring, linting, and schema support verified."
}

main "$@"
