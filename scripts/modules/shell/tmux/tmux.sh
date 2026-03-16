#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_TMUX_DIR="$REPO_ROOT/scripts/modules/shell/tmux"
TARGET_TMUX_CONF="$HOME/.tmux.conf"
TARGET_TMUX_LOCAL_CONF="$HOME/.tmux.local.conf"
TARGET_TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
TPM_DIR="$TARGET_TMUX_PLUGIN_DIR/tpm"
TMUX_RESURRECT_DIR="$TARGET_TMUX_PLUGIN_DIR/tmux-resurrect"
TMUX_CONTINUUM_DIR="$TARGET_TMUX_PLUGIN_DIR/tmux-continuum"
VERIFY_SOCKET_NAME="macdev-verify"
VERIFY_SESSION_NAME="macdev_verify"

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

is_managed_tmux_conf() {
  local dest="$1"

  grep -Fq "mac-dev-setup managed tmux baseline" "$dest" || \
    grep -Fq "mac-dev-setup managed tmux config" "$dest"
}

backup_if_unmanaged() {
  local dest="$1"
  local backup="$2"

  [[ -f "$dest" ]] || return 0
  is_managed_tmux_conf "$dest" && return 0

  if [[ -f "$backup" ]]; then
    log_warn "Overwriting $dest using existing backup at $backup"
    return 0
  fi

  cp "$dest" "$backup"
  log_warn "Backed up existing unmanaged file: $dest -> $backup"
}

cleanup_verify_server() {
  tmux -L "$VERIFY_SOCKET_NAME" kill-session -t "$VERIFY_SESSION_NAME" >/dev/null 2>&1 || true
  tmux -L "$VERIFY_SOCKET_NAME" kill-server >/dev/null 2>&1 || true
}

install_tmux_plugins() {
  mkdir -p "$TARGET_TMUX_PLUGIN_DIR"

  sync_git_checkout "https://github.com/tmux-plugins/tpm" "$TPM_DIR" "tmux plugin manager"
  sync_git_checkout "https://github.com/tmux-plugins/tmux-resurrect" "$TMUX_RESURRECT_DIR" "tmux-resurrect"
  sync_git_checkout "https://github.com/tmux-plugins/tmux-continuum" "$TMUX_CONTINUUM_DIR" "tmux-continuum"
}

install_tmux_config() {
  backup_if_unmanaged "$TARGET_TMUX_CONF" "$TARGET_TMUX_CONF.pre-mac-dev-setup.bak"
  copy_repo_file "$REPO_TMUX_DIR/tmux.conf" "$TARGET_TMUX_CONF"
  copy_repo_file_if_missing "$REPO_TMUX_DIR/local.conf" "$TARGET_TMUX_LOCAL_CONF"
}

verify_tmux() {
  log_info "Verifying tmux configuration..."

  [[ -x "$TPM_DIR/tpm" ]] || die "TPM not installed at $TPM_DIR"
  [[ -f "$TMUX_RESURRECT_DIR/resurrect.tmux" ]] || die "tmux-resurrect not installed at $TMUX_RESURRECT_DIR"
  [[ -f "$TMUX_CONTINUUM_DIR/continuum.tmux" ]] || die "tmux-continuum not installed at $TMUX_CONTINUUM_DIR"

  cleanup_verify_server
  tmux -L "$VERIFY_SOCKET_NAME" -f "$TARGET_TMUX_CONF" new-session -d -s "$VERIFY_SESSION_NAME"
  tmux -L "$VERIFY_SOCKET_NAME" list-sessions >/dev/null
  tmux -L "$VERIFY_SOCKET_NAME" show -s set-clipboard | grep -F "external" >/dev/null
  cleanup_verify_server

  log_success "tmux configuration verified (~/.tmux.conf)."
}

main() {
  brew_install_and_verify_command "tmux" "tmux" "tmux" -V
  install_tmux_plugins
  install_tmux_config
  verify_tmux
}

main "$@"
