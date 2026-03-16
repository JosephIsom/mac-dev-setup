# shellcheck shell=bash
# shellcheck disable=SC2296
# Base completions (mac-dev-setup)
zmodload zsh/complist

mkdir -p "$HOME/.zsh/cache"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'

if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
