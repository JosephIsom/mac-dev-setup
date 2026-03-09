#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_SSH_CONFIG="$REPO_ROOT/home/dot_ssh/config"
TARGET_SSH_DIR="$HOME/.ssh"
TARGET_SSH_CONFIG="$TARGET_SSH_DIR/config"
KEY_PATH="$TARGET_SSH_DIR/id_ed25519"

main() {
  mkdir -p "$TARGET_SSH_DIR"
  chmod 700 "$TARGET_SSH_DIR"

  [[ -f "$REPO_SSH_CONFIG" ]] || die "Missing repo-managed SSH config: $REPO_SSH_CONFIG"
  cp "$REPO_SSH_CONFIG" "$TARGET_SSH_CONFIG"
  chmod 600 "$TARGET_SSH_CONFIG"

  if [[ -f "$KEY_PATH" ]]; then
    log_info "SSH key already exists at $KEY_PATH"
  else
    log_warn "No SSH key found at $KEY_PATH"
    log_warn "Generate one with:"
    log_warn "  ssh-keygen -t ed25519 -C \"$GIT_USER_EMAIL\""
  fi

  log_success "SSH baseline applied."
}

main "$@"
