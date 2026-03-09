#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

install_node_tooling() {
  if ! command_exists_in_zsh npm; then
    die "Neovim toolchain requires npm in zsh."
  fi

  log_info "Installing Neovim Node provider, tree-sitter CLI, and Node-based LSP servers..."
  run_in_login_zsh 'npm install -g neovim tree-sitter-cli bash-language-server pyright typescript-language-server yaml-language-server vscode-langservers-extracted'
}

install_python_tooling() {
  if ! command_exists_in_zsh python; then
    die "Neovim toolchain requires python in zsh."
  fi

  log_info "Installing Python Neovim provider..."
  run_in_login_zsh 'python -m pip install --upgrade pynvim'
}

verify_node_tooling() {
  log_info "Verifying Node-based Neovim tools..."

  run_in_login_zsh 'npm list -g neovim --depth=0 >/dev/null'
  run_in_login_zsh 'tree-sitter --version'
  run_in_login_zsh 'bash-language-server --version'
  run_in_login_zsh 'pyright --version'
  run_in_login_zsh 'typescript-language-server --version'
  run_in_login_zsh 'yaml-language-server --version'

  run_in_login_zsh 'command -v pyright-langserver >/dev/null 2>&1'
  run_in_login_zsh 'command -v vscode-html-language-server >/dev/null 2>&1'
  run_in_login_zsh 'command -v vscode-css-language-server >/dev/null 2>&1'
  run_in_login_zsh 'command -v vscode-json-language-server >/dev/null 2>&1'
}

verify_python_tooling() {
  log_info "Verifying Python Neovim provider..."
  run_in_login_zsh 'python -c "import pynvim; print(pynvim.__version__)"'
}

verify_nvim_health_basics() {
  log_info "Verifying Neovim can start headlessly..."
  nvim --headless "+quitall" >/dev/null 2>&1
}

main() {
  install_node_tooling
  install_python_tooling
  verify_node_tooling
  verify_python_tooling
  verify_nvim_health_basics

  log_success "Neovim toolchain installation verified."
}

main "$@"
