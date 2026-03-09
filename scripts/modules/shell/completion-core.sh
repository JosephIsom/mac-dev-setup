#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_FILE="$REPO_ROOT/home/dot_config/dev-bootstrap/zsh/completions.zsh"
TARGET_FILE="$HOME/.config/dev-bootstrap/zsh/completions.zsh"

main() {
  [[ -f "$REPO_FILE" ]] || die "Missing repo-managed file: $REPO_FILE"
  mkdir -p "$(dirname "$TARGET_FILE")"
  cp "$REPO_FILE" "$TARGET_FILE"

  log_info "Verifying zsh completions config..."
  zsh -i -c 'autoload -Uz compinit && true'
  log_success "Core completion config installed from repo-managed source."
}

main "$@"
