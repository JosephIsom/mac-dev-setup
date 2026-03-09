#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

EXTENSIONS=(
  "ms-python.python"
  "ms-python.debugpy"
  "ms-python.vscode-pylance"
  "golang.go"
  "dbaeumer.vscode-eslint"
  "esbenp.prettier-vscode"
  "ms-azuretools.vscode-docker"
  "editorconfig.editorconfig"
  "github.vscode-pull-request-github"
)

warn_if_vscode_running() {
  if pgrep -x "Code" >/dev/null 2>&1; then
    log_warn "VS Code appears to be running."
    log_warn "Extension installation is more reliable with VS Code closed."
  fi
}

install_extensions() {
  local ext

  log_info "Installing baseline VS Code extensions..."
  for ext in "${EXTENSIONS[@]}"; do
    run_in_login_zsh "code --install-extension $ext --force"
  done
}

verify_extensions() {
  local ext

  log_info "Verifying installed VS Code extensions..."
  for ext in "${EXTENSIONS[@]}"; do
    if ! run_in_login_zsh "code --list-extensions | grep -Fx '$ext' >/dev/null"; then
      die "Expected VS Code extension not installed: $ext"
    fi
  done

  run_in_login_zsh 'code --list-extensions'
  log_success "VS Code baseline extensions installed."
}

main() {
  if ! run_in_login_zsh 'command -v code >/dev/null 2>&1'; then
    die "VS Code extensions require the code CLI. Enable INSTALL_EDITOR_VSCODE_CLI or fix code PATH setup."
  fi

  warn_if_vscode_running
  install_extensions
  verify_extensions
}

main "$@"
