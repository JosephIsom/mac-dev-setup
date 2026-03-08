#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_ZSH_DIR="$HOME/.config/dev-bootstrap/zsh"
P10K_NOTES_FILE="$BOOTSTRAP_ZSH_DIR/p10k-notes.zsh"

main() {
  mkdir -p "$BOOTSTRAP_ZSH_DIR"

  cat > "$P10K_NOTES_FILE" <<'EOF'
# Placeholder for future Powerlevel10k-related bootstrap hooks.
# Intentionally not sourced automatically yet.
# This file exists only to reserve a clean managed location for later work.
EOF

  log_success "Created Powerlevel10k placeholder hook."
}

main "$@"