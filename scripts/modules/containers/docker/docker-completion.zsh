# shellcheck shell=bash
# Docker completion (mac-dev-setup)
if command -v docker >/dev/null 2>&1 && docker completion zsh >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(docker completion zsh)
fi
