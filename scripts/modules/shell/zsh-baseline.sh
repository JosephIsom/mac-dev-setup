#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_ZSH_DIR="$REPO_ROOT/home/dot_config/dev-bootstrap/zsh"
TARGET_ZSH_DIR="$HOME/.config/dev-bootstrap/zsh"
TARGET_PLUGIN_DIR="$TARGET_ZSH_DIR/plugins"
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

copy_repo_file() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || die "Missing repo-managed file: $src"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

main() {
  mkdir -p "$TARGET_ZSH_DIR"
  mkdir -p "$TARGET_PLUGIN_DIR"
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

  copy_repo_file "$REPO_ZSH_DIR/bootstrap.zsh" "$TARGET_ZSH_DIR/bootstrap.zsh"
  copy_repo_file "$REPO_ZSH_DIR/bootstrap.zprofile" "$TARGET_ZSH_DIR/bootstrap.zprofile"
  copy_repo_file "$REPO_ZSH_DIR/aliases.zsh" "$TARGET_ZSH_DIR/aliases.zsh"
  copy_repo_file "$REPO_ZSH_DIR/local.zsh" "$TARGET_ZSH_DIR/local.zsh"

  append_line_if_missing "$USER_ZSHRC" 'source "$HOME/.config/dev-bootstrap/zsh/bootstrap.zsh"'
  append_line_if_missing "$USER_ZPROFILE" 'source "$HOME/.config/dev-bootstrap/zsh/bootstrap.zprofile"'

  log_info "Verifying zsh baseline..."
  zsh -i -c exit
  log_success "zsh baseline installed from repo-managed source files."
}

main "$@"
