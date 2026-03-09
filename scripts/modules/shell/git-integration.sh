#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_FILE="$REPO_ROOT/home/dot_config/dev-bootstrap/zsh/git.zsh"
TARGET_FILE="$HOME/.config/dev-bootstrap/zsh/git.zsh"

main() {
  [[ -f "$REPO_FILE" ]] || die "Missing repo-managed file: $REPO_FILE"
  mkdir -p "$(dirname "$TARGET_FILE")"
  cp "$REPO_FILE" "$TARGET_FILE"

  zsh -i -c 'source "$HOME/.config/dev-bootstrap/zsh/git.zsh"'
  log_success "Git terminal integrations installed from repo-managed source."
}

main "$@"
