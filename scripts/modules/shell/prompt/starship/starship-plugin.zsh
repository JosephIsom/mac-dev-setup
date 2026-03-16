# shellcheck shell=bash
# mac-dev-setup managed prompt loader: starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
