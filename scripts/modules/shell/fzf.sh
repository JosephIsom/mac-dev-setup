#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_ZSH_FILE="$REPO_ROOT/home/dot_config/dev-bootstrap/zsh/fzf.zsh"
TARGET_ZSH_FILE="$HOME/.config/dev-bootstrap/zsh/fzf.zsh"

REPO_NVIM_FILE="$REPO_ROOT/home/dot_config/dev-bootstrap/nvim/plugin/fzf.vim"
TARGET_NVIM_FILE="$HOME/.config/dev-bootstrap/nvim/plugin/fzf.vim"

verify_fzf() {
  command_exists fzf || die "fzf command not found after installation."
  log_info "fzf version:"
  fzf --version

  log_info "Verifying zsh fzf integration..."
  zsh -i -c 'source "$HOME/.config/dev-bootstrap/zsh/fzf.zsh"'

  log_success "fzf installation verified."
}

main() {
  brew_install_formula "fzf"

  [[ -f "$REPO_ZSH_FILE" ]] || die "Missing repo-managed file: $REPO_ZSH_FILE"
  [[ -f "$REPO_NVIM_FILE" ]] || die "Missing repo-managed file: $REPO_NVIM_FILE"

  mkdir -p "$(dirname "$TARGET_ZSH_FILE")"
  mkdir -p "$(dirname "$TARGET_NVIM_FILE")"

  cp "$REPO_ZSH_FILE" "$TARGET_ZSH_FILE"
  cp "$REPO_NVIM_FILE" "$TARGET_NVIM_FILE"

  verify_fzf
}

main "$@"
