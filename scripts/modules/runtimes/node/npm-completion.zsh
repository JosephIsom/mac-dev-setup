# shellcheck shell=bash
# npm completion
if command -v npm >/dev/null 2>&1 && npm completion >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(npm completion)
fi
