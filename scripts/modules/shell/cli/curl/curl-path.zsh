# shellcheck shell=bash
# Homebrew curl PATH wiring (mac-dev-setup)
if [[ -d /opt/homebrew/opt/curl/bin ]]; then
  path=(/opt/homebrew/opt/curl/bin "${path[@]}")
elif [[ -d /usr/local/opt/curl/bin ]]; then
  path=(/usr/local/opt/curl/bin "${path[@]}")
fi
