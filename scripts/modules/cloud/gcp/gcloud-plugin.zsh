# shellcheck shell=bash
# Google Cloud CLI integration (mac-dev-setup)

if [[ -d /opt/homebrew/share/google-cloud-sdk/bin ]]; then
  path=(/opt/homebrew/share/google-cloud-sdk/bin "${path[@]}")
elif [[ -d /usr/local/share/google-cloud-sdk/bin ]]; then
  path=(/usr/local/share/google-cloud-sdk/bin "${path[@]}")
fi

if [[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ]]; then
  # shellcheck disable=SC1091
  source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
elif [[ -f /usr/local/share/google-cloud-sdk/completion.zsh.inc ]]; then
  # shellcheck disable=SC1091
  source /usr/local/share/google-cloud-sdk/completion.zsh.inc
fi
