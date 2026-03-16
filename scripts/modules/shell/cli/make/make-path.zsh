# shellcheck shell=bash
# Homebrew GNU Make PATH wiring (mac-dev-setup)
if [[ -d /opt/homebrew/opt/make/libexec/gnubin ]]; then
  path=(/opt/homebrew/opt/make/libexec/gnubin "${path[@]}")
elif [[ -d /usr/local/opt/make/libexec/gnubin ]]; then
  path=(/usr/local/opt/make/libexec/gnubin "${path[@]}")
fi
