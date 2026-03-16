# shellcheck shell=bash
# shellcheck disable=SC1091,SC2034
# mac-dev-setup managed prompt loader: powerlevel10k
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

if [[ -r "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"
  [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
fi
