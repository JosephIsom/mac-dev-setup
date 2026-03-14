#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_HOME="$REPO_ROOT/home"
REPO_ZSH_DIR="$REPO_ROOT/home/dot_config/zsh"
TARGET_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
TARGET_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
TARGET_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TARGET_ZDOTDIR="$TARGET_CONFIG_HOME/zsh"

copy_repo_file() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || die "Missing repo-managed file: $src"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

copy_repo_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || return 0
  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log_success "Created $dest from repo template"
}

main() {
  # XDG directories for zsh
  mkdir -p "$TARGET_ZDOTDIR/conf.d"
  mkdir -p "$TARGET_ZDOTDIR/plugins"
  mkdir -p "$TARGET_ZDOTDIR/completions"
  mkdir -p "$TARGET_CACHE_HOME/zsh"
  mkdir -p "$TARGET_STATE_HOME/zsh"
  mkdir -p "$TARGET_DATA_HOME"

  # Single file in HOME: .zshenv (sets XDG_* and ZDOTDIR)
  copy_repo_file "$REPO_HOME/dot_zshenv" "$HOME/.zshenv"

  # ZDOTDIR files: .zprofile, .zshrc
  copy_repo_file "$REPO_ZSH_DIR/dot_zprofile" "$TARGET_ZDOTDIR/.zprofile"
  copy_repo_file "$REPO_ZSH_DIR/dot_zshrc" "$TARGET_ZDOTDIR/.zshrc"

  # conf.d: deploy all; do not overwrite 90-local.zsh if it already exists
  for f in "$REPO_ZSH_DIR/conf.d/"*.zsh; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    if [[ "$base" == "90-local.zsh" ]]; then
      copy_repo_file_if_missing "$f" "$TARGET_ZDOTDIR/conf.d/$base"
    else
      copy_repo_file "$f" "$TARGET_ZDOTDIR/conf.d/$base"
    fi
  done

  # Completions and plugins dirs (copy contents, not .gitkeep)
  if [[ -d "$REPO_ZSH_DIR/completions" ]]; then
    for f in "$REPO_ZSH_DIR/completions"/*; do
      [[ -f "$f" ]] || continue
      [[ "$(basename "$f")" == .gitkeep ]] && continue
      copy_repo_file "$f" "$TARGET_ZDOTDIR/completions/$(basename "$f")"
    done
  fi
  if [[ -d "$REPO_ZSH_DIR/plugins" ]]; then
    for f in "$REPO_ZSH_DIR/plugins"/*; do
      [[ -f "$f" ]] || continue
      [[ "$(basename "$f")" == .gitkeep ]] && continue
      copy_repo_file "$f" "$TARGET_ZDOTDIR/plugins/$(basename "$f")"
    done
  fi

  log_info "Verifying zsh baseline (XDG layout)..."
  zsh -i -c exit
  log_success "zsh baseline installed (XDG: ZDOTDIR=$TARGET_ZDOTDIR)."
}

main "$@"
