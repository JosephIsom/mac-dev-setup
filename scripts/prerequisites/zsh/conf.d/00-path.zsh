# shellcheck shell=bash
# PATH and env: Homebrew, mise (mac-dev-setup)
# Homebrew is initialized in ~/.zprofile for login shells. Only re-run shellenv
# here when brew is not already available, which keeps interactive shell startup
# lighter while still handling non-login shells correctly.
if ! command -v brew >/dev/null 2>&1 && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif ! command -v brew >/dev/null 2>&1 && [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
