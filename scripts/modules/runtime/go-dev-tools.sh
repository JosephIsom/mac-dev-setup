#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh go; then
    die "Go dev tools require go in zsh. Enable INSTALL_GO_RUNTIME or fix zsh runtime activation."
  fi

  log_info "Installing gopls..."
  run_in_login_zsh 'go install golang.org/x/tools/gopls@latest'

  log_info "Installing golangci-lint..."
  run_in_login_zsh 'go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest'

  log_info "Installing dlv..."
  run_in_login_zsh 'go install github.com/go-delve/delve/cmd/dlv@latest'

  if ! run_in_login_zsh 'command -v gopls >/dev/null 2>&1'; then
    die "gopls was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v golangci-lint >/dev/null 2>&1'; then
    die "golangci-lint was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v dlv >/dev/null 2>&1'; then
    die "dlv was installed but is not available in zsh."
  fi

  log_info "Verifying Go dev tools in zsh..."
  run_in_login_zsh 'gopls version'
  run_in_login_zsh 'golangci-lint version'
  run_in_login_zsh 'dlv version | head -n 1'

  log_success "Go dev tools installation verified."
}

main "$@"
