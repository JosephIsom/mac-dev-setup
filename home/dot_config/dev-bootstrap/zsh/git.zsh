# dev-bootstrap managed git integrations

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline --decorate --graph -20'
alias gd='git diff'
alias gp='git pull'
alias gps='git push'

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi
