# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# zsh-syntax-highlighting styles

typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS
typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=1'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=5,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=4'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=4'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=6'
ZSH_HIGHLIGHT_STYLES[function]='fg=4'
ZSH_HIGHLIGHT_STYLES[command]='fg=4'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=3'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=244'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=4'
ZSH_HIGHLIGHT_STYLES[path]='fg=6,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=6'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=244'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=3'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=3'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=5'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=5'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=6'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=2'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=2'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=2'
ZSH_HIGHLIGHT_STYLES[assign]='fg=7'
ZSH_HIGHLIGHT_STYLES[comment]='fg=244,italic'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=4'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=2'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=3'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
