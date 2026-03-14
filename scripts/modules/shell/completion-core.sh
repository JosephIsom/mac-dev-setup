#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

# Completions are configured in zsh conf.d (30-completion.zsh) and .zshrc (compinit).
# This module verifies that core completion works in zsh.
main() {
  log_info "Verifying zsh completions (compinit in XDG layout)..."
  zsh -i -c 'autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump" && true'
  log_success "Core completion config verified (XDG zsh)."
}

main "$@"
