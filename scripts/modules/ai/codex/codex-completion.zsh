# shellcheck shell=bash
# Codex completion (mac-dev-setup)
if command -v codex >/dev/null 2>&1 && codex completion zsh >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(codex completion zsh)
fi
