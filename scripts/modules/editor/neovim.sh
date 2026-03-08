#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_NVIM_DIR="$HOME/.config/dev-bootstrap/nvim"
BOOTSTRAP_NVIM_PLUGIN_DIR="$BOOTSTRAP_NVIM_DIR/plugin"
BOOTSTRAP_NVIM_AFTER_PLUGIN_DIR="$BOOTSTRAP_NVIM_DIR/after/plugin"
BOOTSTRAP_NVIM_LUA_DIR="$BOOTSTRAP_NVIM_DIR/lua/dev_bootstrap"
BOOTSTRAP_NVIM_LOCAL_LUA="$BOOTSTRAP_NVIM_DIR/local.lua"

USER_NVIM_DIR="$HOME/.config/nvim"
USER_INIT_VIM="$USER_NVIM_DIR/init.vim"
USER_INIT_LUA="$USER_NVIM_DIR/init.lua"

DEV_BOOTSTRAP_SOURCE_VIM='source ~/.config/dev-bootstrap/nvim/plugin/bootstrap.vim'
DEV_BOOTSTRAP_SOURCE_LUA='vim.cmd([[source ~/.config/dev-bootstrap/nvim/plugin/bootstrap.vim]])'

append_line_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if grep -Fqx "$line" "$file" 2>/dev/null; then
    log_info "Line already present in $file"
    return 0
  fi

  printf '\n%s\n' "$line" >> "$file"
  log_success "Added managed include to $file"
}

write_bootstrap_loader() {
  mkdir -p "$BOOTSTRAP_NVIM_PLUGIN_DIR"
  mkdir -p "$BOOTSTRAP_NVIM_AFTER_PLUGIN_DIR"
  mkdir -p "$BOOTSTRAP_NVIM_LUA_DIR"

  cat > "$BOOTSTRAP_NVIM_PLUGIN_DIR/bootstrap.vim" <<'EOF'
" dev-bootstrap managed Neovim loader

if filereadable(expand('~/.config/dev-bootstrap/nvim/plugin/fzf.vim'))
  source ~/.config/dev-bootstrap/nvim/plugin/fzf.vim
endif

if filereadable(expand('~/.config/dev-bootstrap/nvim/plugin/core.vim'))
  source ~/.config/dev-bootstrap/nvim/plugin/core.vim
endif

lua << EOF_LUA
local local_lua = vim.fn.expand("~/.config/dev-bootstrap/nvim/local.lua")
if vim.fn.filereadable(local_lua) == 1 then
  dofile(local_lua)
end
EOF_LUA
EOF

  cat > "$BOOTSTRAP_NVIM_PLUGIN_DIR/core.vim" <<'EOF'
" dev-bootstrap managed core Neovim settings
" Intentionally minimal for now.
EOF

  cat > "$BOOTSTRAP_NVIM_LOCAL_LUA" <<'EOF'
-- dev-bootstrap user-local Neovim overrides
-- Intentionally left minimal.
EOF
}

ensure_nvim_config_hook() {
  mkdir -p "$USER_NVIM_DIR"

  if [[ -f "$USER_INIT_LUA" ]]; then
    append_line_if_missing "$USER_INIT_LUA" "$DEV_BOOTSTRAP_SOURCE_LUA"
    return 0
  fi

  if [[ -f "$USER_INIT_VIM" ]]; then
    append_line_if_missing "$USER_INIT_VIM" "$DEV_BOOTSTRAP_SOURCE_VIM"
    return 0
  fi

  cat > "$USER_INIT_LUA" <<EOF
$DEV_BOOTSTRAP_SOURCE_LUA
EOF
  log_success "Created $USER_INIT_LUA"
}

verify_neovim() {
  command_exists nvim || die "nvim command not found after installation."
  log_info "Neovim version:"
  nvim --version | head -n 1
  log_success "Neovim installation verified."
}

main() {
  brew_install_formula "neovim"
  write_bootstrap_loader
  ensure_nvim_config_hook
  verify_neovim
}

main "$@"