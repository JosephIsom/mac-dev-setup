#!/usr/bin/env bash

log() {
  printf '%s\n' "$*"
}

log_info() {
  printf '[INFO] %s\n' "$*"
}

log_warn() {
  printf '[WARN] %s\n' "$*"
}

log_error() {
  printf '[ERROR] %s\n' "$*" >&2
}

log_success() {
  printf '[OK] %s\n' "$*"
}

die() {
  log_error "$*"
  exit 1
}

print_banner() {
  printf '\n'
  printf '=========================================\n'
  printf '==  Mac Development Environment Setup  ==\n'
  printf '=========================================\n'
  printf '\n'
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

command_exists_in_zsh() {
  local cmd="$1"
  zsh -i -c "command -v $cmd >/dev/null 2>&1"
}

find_standard_ssh_private_key() {
  local ssh_dir="${1:-$HOME/.ssh}"
  local candidate

  for candidate in \
    "$ssh_dir/id_ed25519" \
    "$ssh_dir/id_ecdsa" \
    "$ssh_dir/id_rsa" \
    "$ssh_dir/id_ed25519_sk" \
    "$ssh_dir/id_ecdsa_sk"; do
    if [[ -f "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

ensure_macos() {
  is_macos || die "This bootstrap currently supports macOS only."
}

brew_bin_path() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    printf '/opt/homebrew/bin/brew'
    return 0
  fi

  if [[ -x /usr/local/bin/brew ]]; then
    printf '/usr/local/bin/brew'
    return 0
  fi

  return 1
}

ensure_brew_available() {
  if command_exists brew; then
    return 0
  fi

  local brew_bin
  if brew_bin="$(brew_bin_path 2>/dev/null)"; then
    eval "$("$brew_bin" shellenv)"
  fi

  command_exists brew || die "brew command is required but not available."
}

brew_install_formula() {
  local formula="$1"
  ensure_brew_available
  log_info "Installing/upgrading Homebrew formula: $formula"
  brew install "$formula"
}

brew_install_cask() {
  local cask="$1"
  ensure_brew_available
  log_info "Installing/upgrading Homebrew cask: $cask"
  brew install --cask "$cask"
}

brew_ensure_tap() {
  local tap="$1"
  ensure_brew_available

  if brew tap | grep -Fx "$tap" >/dev/null 2>&1; then
    log_info "Homebrew tap already present: $tap"
    return 0
  fi

  log_info "Adding Homebrew tap: $tap"
  brew tap "$tap"
}

brew_install_and_verify_command() {
  local formula="$1"
  local cmd="$2"
  local label="$3"
  shift 3

  brew_install_formula "$formula"

  command_exists "$cmd" || die "$cmd command not found after installation."
  log_info "$label version:"
  "$cmd" "$@"
  log_success "$label installation verified."
}

ensure_mise_available() {
  command_exists mise || die "mise command is required but not available."
}

mise_use_global() {
  local tool="$1"
  local version="$2"

  ensure_mise_available
  log_info "Installing/updating via mise: ${tool}@${version}"
  mise use -g "${tool}@${version}"
  mise reshim >/dev/null 2>&1 || true
}

uv_install_global_tool() {
  local package="$1"

  command_exists_in_zsh uv || die "uv must be available in zsh before installing Python tools."
  log_info "Installing/updating Python tool with uv: $package"
  run_in_login_zsh "uv tool install '$package' --force"
}

npm_install_global_package() {
  local package="$1"

  command_exists_in_zsh npm || die "npm must be available in zsh before installing Node-based tools."
  log_info "Installing/updating npm package globally: $package"
  run_in_login_zsh "npm install -g '$package'"
}

go_install_global_package() {
  local package="$1"

  command_exists_in_zsh go || die "go must be available in zsh before installing Go-based tools."
  log_info "Installing/updating Go tool: $package"
  run_in_login_zsh "go install '$package'"
}

cargo_install_global_crate() {
  local crate="$1"

  command_exists_in_zsh cargo || die "cargo must be available in zsh before installing Rust tools."
  log_info "Installing/updating Cargo crate: $crate"
  run_in_login_zsh "cargo install '$crate' --locked --force"
}

gem_install_global_package() {
  local package="$1"

  command_exists_in_zsh gem || die "gem must be available in zsh before installing Ruby tools."
  log_info "Installing/updating Ruby gem globally: $package"
  run_in_login_zsh "gem install '$package' --no-document"
}

homebrew_opt_bin_path() {
  local formula="$1"
  local binary_name="$2"

  if [[ -x "/opt/homebrew/opt/$formula/bin/$binary_name" ]]; then
    printf '/opt/homebrew/opt/%s/bin/%s\n' "$formula" "$binary_name"
    return 0
  fi

  if [[ -x "/usr/local/opt/$formula/bin/$binary_name" ]]; then
    printf '/usr/local/opt/%s/bin/%s\n' "$formula" "$binary_name"
    return 0
  fi

  return 1
}

install_docker_cli_plugin() {
  local formula="$1"
  local plugin_binary="$2"
  local plugin_name="$3"
  local plugin_dir="$HOME/.docker/cli-plugins"
  local plugin_path=""

  brew_install_formula "$formula"
  mkdir -p "$plugin_dir"

  plugin_path="$(homebrew_opt_bin_path "$formula" "$plugin_binary" 2>/dev/null || true)"
  [[ -n "$plugin_path" ]] || die "$plugin_name plugin binary not found in Homebrew opt path for $formula."

  ln -sfn "$plugin_path" "$plugin_dir/$plugin_name"
  [[ -L "$plugin_dir/$plugin_name" || -x "$plugin_dir/$plugin_name" ]] || die "Failed to install Docker CLI plugin link: $plugin_dir/$plugin_name"
}

sync_git_checkout() {
  local repo_url="$1"
  local dest_dir="$2"
  local label="${3:-$(basename "$dest_dir")}"

  command_exists git || die "git command is required to sync $label."

  if [[ -d "$dest_dir/.git" ]]; then
    log_info "Updating $label at $dest_dir"
    git -C "$dest_dir" pull --ff-only
    return 0
  fi

  if [[ -e "$dest_dir" ]]; then
    die "$label path exists but is not a git checkout: $dest_dir"
  fi

  mkdir -p "$(dirname "$dest_dir")"
  log_info "Cloning $label into $dest_dir"
  git clone --depth=1 "$repo_url" "$dest_dir"
}

install_managed_zsh_plugin() {
  local src="$1"
  local target_name="${2:-$(basename "$src")}"
  local target_dir="$HOME/.zsh/plugins"
  local target_path="$target_dir/$target_name"

  [[ -f "$src" ]] || die "Missing repo-managed zsh plugin: $src"

  mkdir -p "$target_dir"
  cp "$src" "$target_path"
  chmod 644 "$target_path"
  printf '%s\n' "$target_path"
}

install_managed_nvim_plugin() {
  local src="$1"
  local target_name="${2:-$(basename "$src")}"
  local target_dir="$HOME/.config/nvim/lua/mac_dev_setup/plugins"
  local target_path="$target_dir/$target_name"

  [[ -f "$src" ]] || die "Missing repo-managed Neovim plugin spec: $src"

  mkdir -p "$target_dir"
  cp "$src" "$target_path"
  chmod 644 "$target_path"
  printf '%s\n' "$target_path"
}

install_managed_vscode_extensions_manifest() {
  local src="$1"
  local target_name="${2:-$(basename "$src")}"
  local target_dir="$HOME/.config/mac-dev-setup/vscode/extensions"
  local target_path="$target_dir/$target_name"

  [[ -f "$src" ]] || die "Missing repo-managed VS Code extensions manifest: $src"

  mkdir -p "$target_dir"
  cp "$src" "$target_path"
  chmod 644 "$target_path"
  printf '%s\n' "$target_path"
}

install_managed_vscode_settings_fragment() {
  local src="$1"
  local target_name="${2:-$(basename "$src")}"
  local target_dir="$HOME/.config/mac-dev-setup/vscode/settings"
  local target_path="$target_dir/$target_name"

  [[ -f "$src" ]] || die "Missing repo-managed VS Code settings fragment: $src"

  mkdir -p "$target_dir"
  cp "$src" "$target_path"
  chmod 644 "$target_path"
  printf '%s\n' "$target_path"
}

install_managed_vscode_template() {
  local src="$1"
  local category="$2"
  local target_name="${3:-$(basename "$src")}"
  local target_dir="$HOME/.config/mac-dev-setup/vscode/templates/$category"
  local target_path="$target_dir/$target_name"

  [[ -f "$src" ]] || die "Missing repo-managed VS Code template: $src"

  mkdir -p "$target_dir"
  cp "$src" "$target_path"
  chmod 644 "$target_path"
  printf '%s\n' "$target_path"
}

reset_managed_vscode_state() {
  local vscode_root="$HOME/.config/mac-dev-setup/vscode"

  log_info "Resetting managed VS Code staged state"

  rm -rf "$vscode_root/extensions" "$vscode_root/settings" "$vscode_root/templates"
  mkdir -p "$vscode_root/extensions" "$vscode_root/settings" "$vscode_root/templates"
}

ensure_local_bin_in_path() {
  local target_dir="$HOME/.local/bin"
  local local_zsh="$HOME/.zsh/conf.d/90-local.zsh"
  local export_line="export PATH=\"\$HOME/.local/bin:\$PATH\""

  mkdir -p "$target_dir"
  mkdir -p "$(dirname "$local_zsh")"
  touch "$local_zsh"

  if ! grep -Fqx "$export_line" "$local_zsh" 2>/dev/null; then
    printf '\n%s\n' "$export_line" >> "$local_zsh"
    log_success "Added ~/.local/bin PATH entry to $local_zsh"
  fi
}

run_in_login_zsh() {
  local cmd="$1"
  zsh -il -c "$cmd"
}

apply_default_user_config() {
  : "${GIT_USER_NAME:=}"
  : "${GIT_USER_EMAIL:=}"

  : "${PYTHON_VERSION:=latest}"
  : "${NODE_VERSION:=lts}"
  : "${GO_VERSION:=latest}"
  : "${JAVA_VERSION:=25}"
  : "${GROOVY_VERSION:=latest}"
  : "${LUA_VERSION:=latest}"
  : "${RUST_VERSION:=latest}"
  : "${BUN_VERSION:=latest}"
  : "${DOTNET_VERSION:=10}"
  : "${RUBY_VERSION:=latest}"
  : "${PHP_VERSION:=latest}"
  : "${KOTLIN_VERSION:=latest}"
  : "${ZIG_VERSION:=latest}"

  : "${COLIMA_CPU:=4}"
  : "${COLIMA_MEMORY:=8}"
  : "${COLIMA_DISK:=60}"
}

load_optional_user_config() {
  local user_file="$CONFIG_DIR/user.env"

  if [[ "${MAC_DEV_SETUP_USER_CONFIG_LOADED:-false}" == "true" ]]; then
    return 0
  fi

  if [[ -f "$user_file" ]]; then
    # shellcheck disable=SC1090
    source "$user_file"
    log_info "Loaded user config: $user_file"
  else
    log_warn "Optional user config not found: $user_file"
  fi

  export MAC_DEV_SETUP_USER_CONFIG_LOADED="true"
}

validate_user_config() {
  if [[ -n "${GITHUB_GIT_PROTOCOL:-}" ]]; then
    log_warn "GITHUB_GIT_PROTOCOL is ignored. GitHub setup now always uses SSH."
  fi
}

prepare_environment() {
  apply_default_user_config
  load_optional_user_config
  apply_default_user_config
  validate_user_config

  export GIT_USER_NAME GIT_USER_EMAIL
  export PYTHON_VERSION NODE_VERSION GO_VERSION JAVA_VERSION GROOVY_VERSION
  export LUA_VERSION RUST_VERSION BUN_VERSION DOTNET_VERSION RUBY_VERSION PHP_VERSION KOTLIN_VERSION ZIG_VERSION
  export COLIMA_CPU COLIMA_MEMORY COLIMA_DISK
}

print_config_summary() {
  log_info "Git identity name set: $([[ -n "${GIT_USER_NAME:-}" ]] && printf yes || printf no)"
  log_info "Git identity email set: $([[ -n "${GIT_USER_EMAIL:-}" ]] && printf yes || printf no)"
  log_info "Runtime versions: python=${PYTHON_VERSION} node=${NODE_VERSION} go=${GO_VERSION} java=${JAVA_VERSION} groovy=${GROOVY_VERSION} lua=${LUA_VERSION}"
  log_info "Colima resources: cpu=${COLIMA_CPU} memory=${COLIMA_MEMORY}GiB disk=${COLIMA_DISK}GiB"
}

run_script_path() {
  local script="$1"
  local label="${2:-${script#"$REPO_ROOT"/}}"

  [[ -f "$script" ]] || die "Script not found: $script"

  log_info "Running: $label"
  bash "$script"
  log_success "Finished: $label"
}
