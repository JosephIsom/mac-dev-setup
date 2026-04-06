# shellcheck shell=bash
# Atuin shell integration (mac-dev-setup)
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi
