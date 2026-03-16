#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_HELM_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/helm/helm-neovim.lua"
TARGET_HELM_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_helm.lua"

install_helm_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_HELM_NVIM_PLUGIN" "$(basename "$TARGET_HELM_NVIM_PLUGIN")" >/dev/null
}

main() {
  command_exists helm || die "helm command must be available before Helm chart support runs."
  brew_install_formula "chart-testing"

  log_info "Verifying Helm chart tooling..."
  helm version
  helm lint --help >/dev/null
  helm template --help >/dev/null
  ct version
  install_helm_neovim_plugin
  [[ -f "$TARGET_HELM_NVIM_PLUGIN" ]] || die "Helm Neovim plugin spec not found at $TARGET_HELM_NVIM_PLUGIN"

  log_success "Helm chart tooling verified."
}

main "$@"
