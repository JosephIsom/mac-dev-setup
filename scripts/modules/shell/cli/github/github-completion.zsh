# shellcheck shell=bash
# GitHub CLI completion
if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi
