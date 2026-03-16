# shellcheck shell=bash
# shellcheck disable=SC1091,SC2034
# zsh-autosuggestions integration (mac-dev-setup)
if [[ -r "$HOME/.zsh/vendor/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  source "$HOME/.zsh/vendor/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
