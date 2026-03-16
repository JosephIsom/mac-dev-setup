#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_MISE_CONFIG="$REPO_ROOT/scripts/prerequisites/mise/config.toml"
MISE_CONFIG_DIR="$HOME/.config/mise"
MISE_GLOBAL_CONFIG="$MISE_CONFIG_DIR/config.toml"
MISE_GLOBAL_CONFIG_BACKUP="$MISE_CONFIG_DIR/config.toml.pre-mac-dev-setup.bak"

backup_existing_mise_config() {
  [[ -f "$MISE_GLOBAL_CONFIG" ]] || return 0
  cmp -s "$REPO_MISE_CONFIG" "$MISE_GLOBAL_CONFIG" && return 0

  if [[ -f "$MISE_GLOBAL_CONFIG_BACKUP" ]]; then
    log_warn "Overwriting mise config using existing backup at $MISE_GLOBAL_CONFIG_BACKUP."
    return 0
  fi

  cp "$MISE_GLOBAL_CONFIG" "$MISE_GLOBAL_CONFIG_BACKUP"
  log_warn "Backed up existing mise config to $MISE_GLOBAL_CONFIG_BACKUP"
}

install_global_config() {
  [[ -f "$REPO_MISE_CONFIG" ]] || die "Missing repo-managed mise config: $REPO_MISE_CONFIG"
  mkdir -p "$MISE_CONFIG_DIR"
  backup_existing_mise_config
  cp "$REPO_MISE_CONFIG" "$MISE_GLOBAL_CONFIG"
  chmod 600 "$MISE_GLOBAL_CONFIG"
}

verify_mise() {
  command_exists mise || die "mise command not found after installation."

  log_info "mise version:"
  mise --version

  [[ -f "$MISE_GLOBAL_CONFIG" ]] || die "mise config not found at $MISE_GLOBAL_CONFIG"
  cmp -s "$REPO_MISE_CONFIG" "$MISE_GLOBAL_CONFIG" || die "mise config does not match the repo-managed file."

  log_info "Verifying mise activation output..."
  mise activate zsh >/dev/null
  log_success "mise installation verified."
}

main() {
  brew_install_formula "mise"
  install_global_config
  verify_mise
}

main "$@"
