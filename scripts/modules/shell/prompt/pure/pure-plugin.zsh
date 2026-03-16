# shellcheck shell=bash
# shellcheck disable=SC1091
# mac-dev-setup managed prompt loader: pure
if [[ -r "$HOME/.config/pure/config.zsh" ]]; then
  source "$HOME/.config/pure/config.zsh"
fi

autoload -U promptinit
promptinit
prompt pure
