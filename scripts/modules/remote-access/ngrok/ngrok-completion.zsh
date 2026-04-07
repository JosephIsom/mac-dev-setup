# shellcheck shell=bash
# ngrok completion
if command -v ngrok >/dev/null 2>&1; then
  eval "$(ngrok completion)"
fi
