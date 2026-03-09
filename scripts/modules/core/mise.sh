#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

MISE_CONFIG_DIR="$HOME/.config/mise"
MISE_GLOBAL_CONFIG="$MISE_CONFIG_DIR/config.toml"

write_global_config() {
  mkdir -p "$MISE_CONFIG_DIR"

  cat > "$MISE_GLOBAL_CONFIG" <<'EOF'
[settings]
idiomatic_version_file_enable_tools = ["python"]
always_keep_download = true
EOF
}

verify_mise() {
  command_exists mise || die "mise command not found after installation."

  log_info "mise version:"
  mise --version

  log_info "Verifying mise in zsh..."
  run_in_login_zsh 'command -v mise >/dev/null 2>&1'
  log_success "mise installation verified."
}

main() {
  brew_install_formula "mise"
  write_global_config
  verify_mise
}

main "$@"