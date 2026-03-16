# shellcheck shell=bash
# shellcheck disable=SC1091,SC2016
# fzf-tab integration (mac-dev-setup)
if [[ -r "$HOME/.zsh/vendor/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.zsh/vendor/fzf-tab/fzf-tab.plugin.zsh"

  zstyle ':fzf-tab:*' switch-group ',' '.'

  if command -v eza >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --icons=always --color=always $realpath'
  fi
fi
