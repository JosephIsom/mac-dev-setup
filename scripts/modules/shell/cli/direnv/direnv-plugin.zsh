# shellcheck shell=bash
# direnv shell integration (mac-dev-setup)
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
