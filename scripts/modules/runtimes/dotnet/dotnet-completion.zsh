# shellcheck shell=bash
# .NET completion
if command -v dotnet >/dev/null 2>&1; then
  eval "$(dotnet completions script zsh)"
fi
