# shellcheck shell=bash
# Spring Boot CLI completion (mac-dev-setup)
if command -v spring >/dev/null 2>&1; then
  eval "$(spring completion zsh)"
fi
