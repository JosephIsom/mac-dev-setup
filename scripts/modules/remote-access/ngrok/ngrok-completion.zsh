# shellcheck shell=bash
# ngrok completion (mac-dev-setup)
if command -v ngrok >/dev/null 2>&1; then
  eval "$(ngrok completion)"
fi
