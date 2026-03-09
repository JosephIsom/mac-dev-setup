# dev-bootstrap managed zsh runtime config

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/completions.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/completions.zsh"
fi

autoload -Uz compinit
if [[ -z "${_DEV_BOOTSTRAP_COMPINIT_DONE:-}" ]]; then
  export _DEV_BOOTSTRAP_COMPINIT_DONE=1
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/fzf.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/fzf.zsh"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/aliases.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/aliases.zsh"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/git.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/git.zsh"
fi

if [[ -d "$HOME/.config/dev-bootstrap/zsh/plugins" ]]; then
  setopt local_options null_glob
  for plugin_file in "$HOME/.config/dev-bootstrap/zsh/plugins/"*.zsh; do
    source "$plugin_file"
  done
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/local.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/local.zsh"
fi
