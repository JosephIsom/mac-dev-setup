# shellcheck shell=bash
# Key bindings (mac-dev-setup)
bindkey -e

# Use Ctrl+Left / Ctrl+Right to move by words in common terminals.
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word

# Make history search and delete behavior predictable across terminal apps.
bindkey '^R' history-incremental-search-backward
bindkey '^[[3~' delete-char
