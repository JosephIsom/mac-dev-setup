#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_CONFIG_DIR="$HOME/.config/dev-bootstrap"
BOOTSTRAP_ZSH_DIR="$BOOTSTRAP_CONFIG_DIR/zsh"
BOOTSTRAP_ZSH_PLUGIN_DIR="$BOOTSTRAP_ZSH_DIR/plugins"
BOOTSTRAP_ZSHRC_FRAGMENT="$BOOTSTRAP_ZSH_DIR/bootstrap.zsh"
BOOTSTRAP_ZPROFILE_FRAGMENT="$BOOTSTRAP_ZSH_DIR/bootstrap.zprofile"
USER_ZSHRC="$HOME/.zshrc"
USER_ZPROFILE="$HOME/.zprofile"

append_line_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if grep -Fqx "$line" "$file" 2>/dev/null; then
    log_info "Line already present in $file"
    return 0
  fi

  printf '\n%s\n' "$line" >> "$file"
  log_success "Added managed include to $file"
}

main() {
  mkdir -p "$BOOTSTRAP_ZSH_DIR"
  mkdir -p "$BOOTSTRAP_ZSH_PLUGIN_DIR"
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

  cat > "$BOOTSTRAP_ZSHRC_FRAGMENT" <<'EOF'
# dev-bootstrap managed zsh runtime config

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/completions.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/completions.zsh"
fi

autoload -Uz compinit
if [[ -z "${_DEV_BOOTSTRAP_COMPINIT_DONE:-}" ]]; then
  export _DEV_BOOTSTRAP_COMPINIT_DONE=1
  compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/fzf.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/fzf.zsh"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/aliases.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/aliases.zsh"
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/git.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/git.zsh"
fi

if [[ -d "$HOME/.config/dev-bootstrap/zsh/plugins" ]]; then
  for plugin_file in "$HOME/.config/dev-bootstrap/zsh/plugins/"*.zsh; do
    [[ -e "$plugin_file" ]] || continue
    source "$plugin_file"
  done
fi

if [[ -f "$HOME/.config/dev-bootstrap/zsh/local.zsh" ]]; then
  source "$HOME/.config/dev-bootstrap/zsh/local.zsh"
fi
EOF

  cat > "$BOOTSTRAP_ZPROFILE_FRAGMENT" <<'EOF'
# dev-bootstrap managed zsh login config
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
EOF

  cat > "$BOOTSTRAP_ZSH_DIR/aliases.zsh" <<'EOF'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
EOF

  cat > "$BOOTSTRAP_ZSH_DIR/local.zsh" <<'EOF'
# dev-bootstrap user-local zsh overrides
# Intentionally left minimal.
# Add personal aliases, exports, or source statements here later.
EOF

  cat > "$BOOTSTRAP_ZSH_PLUGIN_DIR/.keep" <<'EOF'
# placeholder to preserve plugin directory
EOF

  append_line_if_missing "$USER_ZSHRC" 'source "$HOME/.config/dev-bootstrap/zsh/bootstrap.zsh"'
  append_line_if_missing "$USER_ZPROFILE" 'source "$HOME/.config/dev-bootstrap/zsh/bootstrap.zprofile"'

  log_info "Verifying zsh baseline..."
  zsh -i -c exit
  log_success "zsh baseline installed without replacing existing Powerlevel10k or user config."
}

main "$@"