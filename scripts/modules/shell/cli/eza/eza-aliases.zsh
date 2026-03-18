# shellcheck shell=bash
# eza aliases (mac-dev-setup)
alias ls='eza --icons=auto'
alias l='eza -1'
alias la='eza -la --icons=auto'
# alias ll='eza -lh --git --icons=auto'
alias lt='eza --tree --level=2 --icons=auto'
alias ll='eza --all --oneline --long --header --inode --flags --bytes --group --modified --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first --sort=name --color=always --icons=auto --no-quotes --group --git --git-repos --mounts'
