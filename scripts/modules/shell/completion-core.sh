#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_ZSH_DIR="$HOME/.config/dev-bootstrap/zsh"
COMPLETIONS_FILE="$BOOTSTRAP_ZSH_DIR/completions.zsh"

main() {
  mkdir -p "$BOOTSTRAP_ZSH_DIR"

  cat > "$COMPLETIONS_FILE" <<'EOF'
# dev-bootstrap managed completion config

typeset -gaU fpath

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

if [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
EOF

  log_info "Verifying zsh completions config..."
  zsh -i -c 'autoload -Uz compinit && true'
  log_success "Core completion config installed."
}

main "$@"