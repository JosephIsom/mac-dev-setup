# shellcheck shell=bash
# shellcheck disable=SC1091
# fzf shell integration (mac-dev-setup)
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
  [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/local/opt/fzf/shell/completion.zsh ]]; then
  source /usr/local/opt/fzf/shell/completion.zsh
  [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]] && source /usr/local/opt/fzf/shell/key-bindings.zsh
fi
