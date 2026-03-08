#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_ZSH_DIR="$HOME/.config/dev-bootstrap/zsh"
GIT_FILE="$BOOTSTRAP_ZSH_DIR/git.zsh"

main() {
  mkdir -p "$BOOTSTRAP_ZSH_DIR"

  cat > "$GIT_FILE" <<'EOF'
# dev-bootstrap managed git integrations

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline --decorate --graph -20'
alias gd='git diff'
alias gp='git pull'
alias gps='git push'

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi
EOF

  zsh -i -c 'source "$HOME/.config/dev-bootstrap/zsh/git.zsh"'
  log_success "git terminal integrations installed."
}

main "$@"