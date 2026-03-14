#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_TMUX_DIR="$REPO_ROOT/home/dot_config/tmux"
TARGET_TMUX_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
USER_TMUX_CONF="$HOME/.tmux.conf"
MANAGED_SOURCE_LINE='source-file ~/.config/tmux/tmux.conf'
VERIFY_SESSION="macdev_verify"

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

cleanup_verify_session() {
  tmux kill-session -t "$VERIFY_SESSION" >/dev/null 2>&1 || true
  tmux kill-server >/dev/null 2>&1 || true
}

verify_tmux() {
  command_exists tmux || die "tmux command not found."

  log_info "tmux version:"
  tmux -V

  log_info "Verifying tmux config parse..."
  cleanup_verify_session
  tmux new-session -d -s "$VERIFY_SESSION"
  tmux source-file "$TARGET_TMUX_DIR/tmux.conf"
  cleanup_verify_session

  log_success "tmux baseline verified (XDG: $TARGET_TMUX_DIR)."
}

main() {
  mkdir -p "$TARGET_TMUX_DIR"

  copy_repo_file "$REPO_TMUX_DIR/tmux.conf" "$TARGET_TMUX_DIR/tmux.conf"
  copy_repo_file "$REPO_TMUX_DIR/local.conf" "$TARGET_TMUX_DIR/local.conf"

  append_line_if_missing "$USER_TMUX_CONF" "$MANAGED_SOURCE_LINE"

  verify_tmux
}

main "$@"
