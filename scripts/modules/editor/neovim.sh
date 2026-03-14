#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_NVIM_DIR="$REPO_ROOT/home/dot_config/nvim"
TARGET_NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
TARGET_PLUGIN_DIR="$TARGET_NVIM_DIR/plugin"
TARGET_LUA_DIR="$TARGET_NVIM_DIR/lua/dev_bootstrap"
USER_INIT_VIM="$TARGET_NVIM_DIR/init.vim"
USER_INIT_LUA="$TARGET_NVIM_DIR/init.lua"

BOOTSTRAP_SOURCE_VIM='source ~/.config/nvim/plugin/bootstrap.vim'
BOOTSTRAP_SOURCE_LUA='vim.cmd([[source ~/.config/nvim/plugin/bootstrap.vim]])'

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

copy_repo_tree_clean() {
  local src_dir="$1"
  local dest_dir="$2"

  [[ -d "$src_dir" ]] || die "Missing repo-managed directory: $src_dir"
  rm -rf "$dest_dir"
  mkdir -p "$dest_dir"
  cp -R "$src_dir"/. "$dest_dir"/
}

ensure_nvim_config_hook() {
  mkdir -p "$TARGET_NVIM_DIR"

  if [[ -f "$USER_INIT_LUA" ]]; then
    append_line_if_missing "$USER_INIT_LUA" "$BOOTSTRAP_SOURCE_LUA"
    return 0
  fi

  if [[ -f "$USER_INIT_VIM" ]]; then
    append_line_if_missing "$USER_INIT_VIM" "$BOOTSTRAP_SOURCE_VIM"
    return 0
  fi

  cat > "$USER_INIT_LUA" <<EOF
$BOOTSTRAP_SOURCE_LUA
EOF
  log_success "Created $USER_INIT_LUA (XDG: $TARGET_NVIM_DIR)"
}

bootstrap_plugins() {
  log_info "Bootstrapping Neovim plugins with lazy.nvim..."
  nvim --headless "+Lazy! sync" +qa || true
}

verify_neovim() {
  command_exists nvim || die "nvim command not found after installation."

  log_info "Neovim version:"
  nvim --version | head -n 1

  log_success "Neovim baseline installation completed (XDG: $TARGET_NVIM_DIR)."
}

main() {
  brew_install_formula "neovim"
  brew_install_formula "tree-sitter"

  mkdir -p "$TARGET_NVIM_DIR"

  copy_repo_tree_clean "$REPO_NVIM_DIR/plugin" "$TARGET_PLUGIN_DIR"
  copy_repo_tree_clean "$REPO_NVIM_DIR/lua/dev_bootstrap" "$TARGET_LUA_DIR"

  if [[ -f "$REPO_NVIM_DIR/local.lua" ]]; then
    cp "$REPO_NVIM_DIR/local.lua" "$TARGET_NVIM_DIR/local.lua"
  fi

  ensure_nvim_config_hook
  bootstrap_plugins
  verify_neovim
}

main "$@"
