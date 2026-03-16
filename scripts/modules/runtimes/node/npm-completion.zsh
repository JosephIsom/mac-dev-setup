# shellcheck shell=bash
# npm completion (mac-dev-setup)
if command -v npm >/dev/null 2>&1 && npm completion >/dev/null 2>&1; then
  # shellcheck disable=SC1090
  source <(npm completion)
fi
