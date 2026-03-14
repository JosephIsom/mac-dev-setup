# Plugins: fzf and optional plugins dir (mac-dev-setup)
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [[ -f /usr/local/opt/fzf/shell/completion.zsh ]]; then
  source /usr/local/opt/fzf/shell/completion.zsh
fi
if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

if [[ -d "$ZDOTDIR/plugins" ]]; then
  setopt local_options null_glob
  for plugin_file in "$ZDOTDIR/plugins/"*.zsh; do
    source "$plugin_file"
  done
fi
