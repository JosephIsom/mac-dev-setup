# shellcheck shell=bash
# zoxide shell integration
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
