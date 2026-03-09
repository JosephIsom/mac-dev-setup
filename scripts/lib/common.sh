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
  printf '========================================\n'
  printf 'mac-dev-setup bootstrap\n'
  printf '========================================\n'
  printf '\n'
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

command_exists_in_zsh() {
  local cmd="$1"
  zsh -i -c "command -v $cmd >/dev/null 2>&1"
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

ensure_macos() {
  is_macos || die "This bootstrap currently supports macOS only."
}

bool_is_true() {
  [[ "${1:-false}" == "true" ]]
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

run_in_login_zsh() {
  local cmd="$1"
  zsh -i -c "$cmd"
}

run_module() {
  local group="$1"
  local name="$2"
  local script="$MODULES_DIR/$group/$name.sh"

  if [[ ! -f "$script" ]]; then
    die "Module script not found: $script"
  fi

  log_info "Running module: $group/$name"
  bash "$script"
  log_success "Finished module: $group/$name"
}