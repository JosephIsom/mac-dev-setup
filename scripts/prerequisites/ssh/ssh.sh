#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SSH_CONFIG="$REPO_ROOT/scripts/prerequisites/ssh/config"
TARGET_SSH_DIR="$HOME/.ssh"
TARGET_SSH_CONFIG_DIR="$TARGET_SSH_DIR/config.d"
TARGET_SSH_CONFIG="$TARGET_SSH_DIR/config"
TARGET_BASELINE_CONFIG="$TARGET_SSH_CONFIG_DIR/00-mac-dev-setup.conf"

ensure_ssh_layout() {
  mkdir -p "$TARGET_SSH_DIR"
  mkdir -p "$TARGET_SSH_CONFIG_DIR"
  chmod 700 "$TARGET_SSH_DIR"
  chmod 700 "$TARGET_SSH_CONFIG_DIR"
}

ensure_ssh_tools_available() {
  command_exists ssh || die "ssh command not found."
  command_exists ssh-keygen || die "ssh-keygen command not found."
}

sync_main_ssh_config() {
  local temp_config=""

  temp_config="$(mktemp "${TMPDIR:-/tmp}/mac-dev-setup-ssh-config.XXXXXX")"

  {
    cat <<'EOF'
# User SSH config
Include ~/.ssh/config.d/*.conf
Include ~/.ssh/config.local
EOF

    if [[ -f "$TARGET_SSH_CONFIG" ]]; then
      printf '\n'
      while IFS= read -r line || [[ -n "$line" ]]; do
        case "$line" in
          '# User SSH config'|'Include ~/.ssh/config.d/*.conf'|'Include ~/.ssh/config.local') continue ;;
        esac
        printf '%s\n' "$line"
      done < "$TARGET_SSH_CONFIG"
    fi
  } > "$temp_config"

  mv "$temp_config" "$TARGET_SSH_CONFIG"
  chmod 600 "$TARGET_SSH_CONFIG"

  if [[ -s "$TARGET_SSH_CONFIG" ]]; then
    log_info "Ensured SSH config includes are present at the top of $TARGET_SSH_CONFIG"
  fi
}

install_managed_ssh_config() {
  [[ -f "$REPO_SSH_CONFIG" ]] || die "Missing repo-managed SSH config: $REPO_SSH_CONFIG"
  cp "$REPO_SSH_CONFIG" "$TARGET_BASELINE_CONFIG"
  chmod 600 "$TARGET_BASELINE_CONFIG"
  log_info "Installed managed SSH baseline: $TARGET_BASELINE_CONFIG"
}

report_ssh_key_status() {
  local key_path=""

  key_path="$(find_standard_ssh_private_key "$TARGET_SSH_DIR" 2>/dev/null || true)"

  if [[ -n "$key_path" ]]; then
    log_info "SSH key already exists at $key_path"
    return 0
  fi

  log_warn "No standard SSH private key found in $TARGET_SSH_DIR"
  log_info "Generate one later if you need SSH-based Git remotes or host access."
}

main() {
  ensure_ssh_tools_available
  ensure_ssh_layout
  sync_main_ssh_config
  install_managed_ssh_config
  report_ssh_key_status

  log_success "SSH baseline applied."
}

main "$@"
