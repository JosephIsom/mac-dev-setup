# shellcheck shell=bash
# Bitwarden CLI completion (mac-dev-setup)
if command -v bw >/dev/null 2>&1 && bw completion --shell zsh >/dev/null 2>&1; then
  eval "$(bw completion --shell zsh)"
  compdef _bw bw
fi
