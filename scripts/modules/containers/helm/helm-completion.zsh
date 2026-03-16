# shellcheck shell=bash
# Helm completion (mac-dev-setup)
if command -v helm >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(helm completion zsh)
fi
