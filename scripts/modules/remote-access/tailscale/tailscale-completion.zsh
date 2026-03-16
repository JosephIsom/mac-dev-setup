# shellcheck shell=bash
# Tailscale completion (mac-dev-setup)
if command -v tailscale >/dev/null 2>&1 && tailscale completion zsh >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(tailscale completion zsh)
fi
