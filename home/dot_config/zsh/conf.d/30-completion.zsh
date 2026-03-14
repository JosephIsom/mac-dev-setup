# Completions (mac-dev-setup)
typeset -gaU fpath

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

if [[ -d /usr/local/share/zsh/site-functions ]]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi
