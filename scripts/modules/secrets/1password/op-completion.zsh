# shellcheck shell=bash
# 1Password CLI completion (mac-dev-setup)
if command -v op >/dev/null 2>&1 && op completion zsh >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(op completion zsh)
fi
