# shellcheck shell=bash
# DigitalOcean doctl completion (mac-dev-setup)
if command -v doctl >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(doctl completion zsh)
fi
