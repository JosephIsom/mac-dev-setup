# shellcheck shell=bash
# mac-dev-setup managed prompt loader: oh-my-posh
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/ohmyposh/config.omp.json")"
fi
