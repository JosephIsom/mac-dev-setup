#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

TARGET_SSH_DIR="$HOME/.ssh"
TARGET_SSH_CONFIG_DIR="$TARGET_SSH_DIR/config.d"
TARGET_GITHUB_CONFIG="$TARGET_SSH_CONFIG_DIR/10-github.conf"

ensure_ssh_layout() {
  mkdir -p "$TARGET_SSH_DIR"
  mkdir -p "$TARGET_SSH_CONFIG_DIR"
  chmod 700 "$TARGET_SSH_DIR"
  chmod 700 "$TARGET_SSH_CONFIG_DIR"
}

install_github_ssh_config() {
  cat > "$TARGET_GITHUB_CONFIG" <<'EOF'
Host github.com
  HostName github.com
  User git
EOF
  chmod 600 "$TARGET_GITHUB_CONFIG"
  log_info "Installed GitHub SSH host config: $TARGET_GITHUB_CONFIG"
}

report_github_ssh_key_guidance() {
  local key_email="your-email@example.com"

  if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
    key_email="$GIT_USER_EMAIL"
  fi

  log_warn "GitHub SSH is enabled, but no key setup was verified."
  log_warn "Generate one with:"
  log_warn "  ssh-keygen -t ed25519 -C \"$key_email\""
  log_warn "Then add the public key to GitHub and test with: ssh -T git@github.com"
}

check_github_ssh_connectivity() {
  local status=0

  command_exists ssh || die "ssh command not found."

  log_info "Checking GitHub SSH connectivity..."
  set +e
  ssh \
    -o BatchMode=yes \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=accept-new \
    -T git@github.com
  status=$?
  set -e

  case "$status" in
    1)
      log_success "GitHub SSH appears reachable. Exit code 1 is normal for successful auth test."
      ;;
    255)
      log_warn "GitHub SSH check failed. Ensure your SSH key is added to GitHub and agent/keychain is configured."
      ;;
    *)
      log_warn "GitHub SSH returned exit code $status. Review the output above."
      ;;
  esac
}

main() {
  local key_path=""

  ensure_ssh_layout
  install_github_ssh_config

  key_path="$(find_standard_ssh_private_key "$TARGET_SSH_DIR" 2>/dev/null || true)"
  if [[ -n "$key_path" ]]; then
    log_info "GitHub SSH key detected at $key_path"
    check_github_ssh_connectivity
  else
    report_github_ssh_key_guidance
  fi

  log_success "GitHub SSH configuration applied."
}

main "$@"
