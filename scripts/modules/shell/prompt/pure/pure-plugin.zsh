# shellcheck shell=bash
# shellcheck disable=SC1091
# managed prompt loader: pure
if [[ -r "$HOME/.config/pure/config.zsh" ]]; then
  source "$HOME/.config/pure/config.zsh"
fi

setopt prompt_subst

autoload -U promptinit; promptinit
prompt pure
