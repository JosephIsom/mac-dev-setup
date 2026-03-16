# shellcheck shell=bash
# Task completion (mac-dev-setup)
if command -v task >/dev/null 2>&1; then
  eval "$(task --completion zsh)"
fi
