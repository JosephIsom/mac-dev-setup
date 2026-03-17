#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_NVIM_ASSETS_DIR="$REPO_ROOT/scripts/modules/editors/neovim/assets"
REPO_NVIM_INIT="$REPO_NVIM_ASSETS_DIR/init.lua"
REPO_NVIM_LUA_DIR="$REPO_NVIM_ASSETS_DIR/lua/mac_dev_setup"

TARGET_NVIM_DIR="$HOME/.config/nvim"
TARGET_NVIM_INIT="$TARGET_NVIM_DIR/init.lua"
TARGET_NVIM_LUA_DIR="$TARGET_NVIM_DIR/lua/mac_dev_setup"
TARGET_NVIM_LOCAL_FILE="$TARGET_NVIM_LUA_DIR/local.lua"
TARGET_NVIM_PLUGIN_DIR="$TARGET_NVIM_LUA_DIR/plugins"

LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
MANAGED_MARKER="mac-dev-setup managed Neovim baseline"

backup_if_unmanaged() {
  local backup_dir="$TARGET_NVIM_DIR.pre-mac-dev-setup.bak"

  [[ -f "$TARGET_NVIM_INIT" ]] || return 0
  grep -Fq "$MANAGED_MARKER" "$TARGET_NVIM_INIT" && return 0

  if [[ -d "$backup_dir" ]]; then
    log_warn "Neovim config is already backed up at $backup_dir"
    return 0
  fi

  cp -R "$TARGET_NVIM_DIR" "$backup_dir"
  log_warn "Backed up existing unmanaged Neovim config to $backup_dir"
}

copy_repo_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || return 0

  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log_success "Created $dest from repo template"
}

install_config() {
  local lua_file

  [[ -f "$REPO_NVIM_INIT" ]] || die "Missing repo-managed Neovim init.lua: $REPO_NVIM_INIT"
  [[ -d "$REPO_NVIM_LUA_DIR" ]] || die "Missing repo-managed Neovim Lua config directory: $REPO_NVIM_LUA_DIR"

  backup_if_unmanaged

  mkdir -p "$TARGET_NVIM_LUA_DIR/config" "$TARGET_NVIM_PLUGIN_DIR"
  cp "$REPO_NVIM_INIT" "$TARGET_NVIM_INIT"
  for lua_file in "$REPO_NVIM_LUA_DIR/"*.lua; do
    [[ -f "$lua_file" ]] || continue
    [[ "$(basename "$lua_file")" == "local.lua" ]] && continue
    cp "$lua_file" "$TARGET_NVIM_LUA_DIR/"
  done
  cp -R "$REPO_NVIM_LUA_DIR/config/." "$TARGET_NVIM_LUA_DIR/config/"
  cp -R "$REPO_NVIM_LUA_DIR/plugins/." "$TARGET_NVIM_PLUGIN_DIR/"
  copy_repo_file_if_missing "$REPO_NVIM_LUA_DIR/local.lua" "$TARGET_NVIM_LOCAL_FILE"
}

bootstrap_lazy_nvim() {
  command_exists git || die "git is required to bootstrap lazy.nvim."

  if [[ -d "$LAZY_DIR/.git" ]]; then
    log_info "Updating lazy.nvim at $LAZY_DIR"
    git -C "$LAZY_DIR" checkout stable >/dev/null 2>&1 || true
    git -C "$LAZY_DIR" pull --ff-only origin stable
    return 0
  fi

  mkdir -p "$(dirname "$LAZY_DIR")"
  log_info "Cloning lazy.nvim into $LAZY_DIR"
  git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_DIR"
}

sync_plugins() {
  command_exists_in_zsh nvim || die "nvim command not found in zsh after installation."
  log_info "Syncing Neovim baseline plugins"
  run_in_login_zsh 'nvim --headless "+Lazy! sync" "+qa"'
}

verify_install() {
  command_exists_in_zsh nvim || die "nvim command not found in zsh after installation."
  [[ -f "$TARGET_NVIM_INIT" ]] || die "Neovim init.lua not found at $TARGET_NVIM_INIT after installation."
  [[ -f "$TARGET_NVIM_LUA_DIR/config/lazy.lua" ]] || die "Neovim lazy.nvim config not found after installation."
  [[ -f "$TARGET_NVIM_LUA_DIR/plugins/ui.lua" ]] || die "Neovim baseline UI plugin spec not found after installation."
  [[ -f "$TARGET_NVIM_LUA_DIR/theme.lua" ]] || die "Neovim theme module not found at $TARGET_NVIM_LUA_DIR/theme.lua after installation."
  [[ -f "$TARGET_NVIM_LOCAL_FILE" ]] || die "Neovim local override file not found at $TARGET_NVIM_LOCAL_FILE after installation."
  [[ -d "$LAZY_DIR" ]] || die "lazy.nvim checkout not found at $LAZY_DIR after installation."
  grep -Fq "$MANAGED_MARKER" "$TARGET_NVIM_INIT" || die "Neovim init.lua is missing the managed marker."
  run_in_login_zsh 'nvim --headless "+qa"'
}

main() {
  brew_install_formula "neovim"
  install_config
  bootstrap_lazy_nvim
  sync_plugins
  verify_install

  log_info "Neovim version:"
  run_in_login_zsh 'nvim --version | head -n 1'
  log_success "Neovim installation and baseline config verified."
}

main "$@"
