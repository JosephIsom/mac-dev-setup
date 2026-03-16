# shellcheck shell=bash
# Cloudflare Wrangler completion (mac-dev-setup)
if command -v wrangler >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(wrangler complete zsh)
fi
