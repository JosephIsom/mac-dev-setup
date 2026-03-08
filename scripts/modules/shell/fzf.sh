#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_ZSH_DIR="$HOME/.config/dev-bootstrap/zsh"
FZF_ZSH_FILE="$BOOTSTRAP_ZSH_DIR/fzf.zsh"

BOOTSTRAP_NVIM_DIR="$HOME/.config/dev-bootstrap/nvim"
BOOTSTRAP_VIM_DIR="$HOME/.config/dev-bootstrap/vim"
BOOTSTRAP_NVIM_PLUGIN_DIR="$BOOTSTRAP_NVIM_DIR/plugin"
FZF_VIM_FILE="$BOOTSTRAP_VIM_DIR/fzf.vim"
FZF_NVIM_FILE="$BOOTSTRAP_NVIM_PLUGIN_DIR/fzf.vim"

write_zsh_integration() {
  mkdir -p "$BOOTSTRAP_ZSH_DIR"

  cat > "$FZF_ZSH_FILE" <<'EOF'
# dev-bootstrap managed fzf integration

if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

if [[ -f /usr/local/opt/fzf/shell/completion.zsh ]]; then
  source /usr/local/opt/fzf/shell/completion.zsh
fi

if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi
EOF
}

write_vim_integration() {
  mkdir -p "$BOOTSTRAP_VIM_DIR"
  mkdir -p "$BOOTSTRAP_NVIM_PLUGIN_DIR"

  cat > "$FZF_VIM_FILE" <<'EOF'
" dev-bootstrap managed fzf Vim integration
if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf
endif
EOF

  cat > "$FZF_NVIM_FILE" <<'EOF'
" dev-bootstrap managed fzf Neovim integration
if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf
endif
EOF
}

verify_fzf() {
  command_exists fzf || die "fzf command not found after installation."
  log_info "fzf version:"
  fzf --version

  log_info "Verifying zsh fzf integration..."
  zsh -i -c 'source "$HOME/.config/dev-bootstrap/zsh/fzf.zsh"'

  log_success "fzf installation verified."
}

main() {
  brew_install_formula "fzf"
  write_zsh_integration
  write_vim_integration
  verify_fzf
}

main "$@"