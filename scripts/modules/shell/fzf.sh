#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_NVIM_FILE="$REPO_ROOT/home/dot_config/nvim/plugin/fzf.vim"
TARGET_NVIM_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugin/fzf.vim"

verify_fzf() {
  command_exists fzf || die "fzf command not found after installation."
  log_info "fzf version:"
  fzf --version

  log_info "Verifying zsh fzf integration (sourced from conf.d/40-plugins.zsh)..."
  zsh -i -c exit

  log_success "fzf installation verified."
}

main() {
  brew_install_formula "fzf"

  [[ -f "$REPO_NVIM_FILE" ]] || die "Missing repo-managed file: $REPO_NVIM_FILE"
  mkdir -p "$(dirname "$TARGET_NVIM_FILE")"
  cp "$REPO_NVIM_FILE" "$TARGET_NVIM_FILE"

  verify_fzf
}

main "$@"
