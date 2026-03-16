# shellcheck shell=bash
# Fly.io CLI integration (mac-dev-setup)

if ! command -v fly >/dev/null 2>&1 && command -v flyctl >/dev/null 2>&1; then
  alias fly=flyctl
fi

if command -v fly >/dev/null 2>&1; then
  if fly completion zsh >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source <(fly completion zsh)
  elif fly version -c zsh >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source <(fly version -c zsh)
  fi
elif command -v flyctl >/dev/null 2>&1; then
  if flyctl completion zsh >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source <(flyctl completion zsh)
  elif flyctl version -c zsh >/dev/null 2>&1; then
    # shellcheck disable=SC1090
    source <(flyctl version -c zsh)
  fi
fi
