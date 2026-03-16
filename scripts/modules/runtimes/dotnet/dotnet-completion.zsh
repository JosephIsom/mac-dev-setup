# shellcheck shell=bash
# .NET completion (mac-dev-setup)
if command -v dotnet >/dev/null 2>&1; then
  eval "$(dotnet completions script zsh)"
fi
