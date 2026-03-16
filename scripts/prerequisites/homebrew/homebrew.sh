#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

BREW_DOCTOR_IGNORE_PATTERNS=(
  'unknown or unsupported macOS version'
)

MAC_DEV_SETUP_STRICT_BREW_DOCTOR="${MAC_DEV_SETUP_STRICT_BREW_DOCTOR:-false}"

print_command_output() {
  local output="$1"

  if [[ -n "$output" ]]; then
    printf '%s\n' "$output"
  fi
}

brew_output_matches_ignore_patterns() {
  local output="$1"
  local ignore_pattern

  for ignore_pattern in "${BREW_DOCTOR_IGNORE_PATTERNS[@]}"; do
    if grep -qi "$ignore_pattern" <<<"$output"; then
      return 0
    fi
  done

  return 1
}

run_brew() {
  if command_exists brew; then
    brew "$@"
    return
  fi

  local brew_bin
  brew_bin="$(brew_bin_path 2>/dev/null)" || die "brew command not found."
  "$brew_bin" "$@"
}

ensure_brew_shellenv_loaded() {
  if command_exists brew; then
    return 0
  fi

  local brew_bin
  if brew_bin="$(brew_bin_path 2>/dev/null)"; then
    eval "$("$brew_bin" shellenv)"
  fi

  command -v brew >/dev/null 2>&1 || die "brew command not found after installation."
}

validate_brew_settings() {
  case "$MAC_DEV_SETUP_STRICT_BREW_DOCTOR" in
    true|false) ;;
    *) die "MAC_DEV_SETUP_STRICT_BREW_DOCTOR must be true or false." ;;
  esac
}

log_brew_binary() {
  local brew_bin=""

  brew_bin="$(command -v brew 2>/dev/null || brew_bin_path 2>/dev/null || true)"
  if [[ -n "$brew_bin" ]]; then
    log_info "Homebrew binary: $brew_bin"
  fi
}

install_homebrew_if_missing() {
  if command_exists brew || brew_bin_path >/dev/null 2>&1; then
    ensure_brew_shellenv_loaded
    log_success "Homebrew already installed."
    log_brew_binary
    return 0
  fi

  command_exists curl || die "curl is required to install Homebrew."
  log_info "Installing Homebrew using the official install script..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_shellenv_loaded
  log_success "Homebrew installation completed."
  log_brew_binary
}

update_homebrew() {
  log_info "Updating Homebrew..."
  local update_output="" update_status=0
  update_output="$(run_brew update 2>&1)" || update_status=$?

  print_command_output "$update_output"

  if [[ "$update_status" -ne 0 ]]; then
    if brew_output_matches_ignore_patterns "$update_output"; then
      log_warn "brew update hit a macOS version support issue. Continuing with the installed Homebrew."
    else
      die "brew update failed. See output above."
    fi
  fi

  log_success "Homebrew update step completed."
}

doctor_homebrew() {
  log_info "Running brew doctor..."
  local doctor_output="" doctor_status=0
  doctor_output="$(run_brew doctor 2>&1)" || doctor_status=$?

  print_command_output "$doctor_output"

  if [[ "$doctor_status" -eq 0 ]]; then
    log_success "brew doctor passed."
    return 0
  fi

  if brew_output_matches_ignore_patterns "$doctor_output"; then
    log_warn "brew doctor reported a known ignorable issue on this macOS version. Continuing."
    return 0
  fi

  if [[ "$MAC_DEV_SETUP_STRICT_BREW_DOCTOR" == "true" ]]; then
    die "brew doctor reported issues that require attention."
  fi

  log_warn "brew doctor reported advisory issues. Continuing bootstrap."
  log_warn "Set MAC_DEV_SETUP_STRICT_BREW_DOCTOR=true to make brew doctor failures blocking."
}

main() {
  validate_brew_settings
  install_homebrew_if_missing
  ensure_brew_shellenv_loaded

  log_info "Homebrew version:"
  run_brew --version

  update_homebrew

  log_info "Homebrew version after update:"
  run_brew --version

  doctor_homebrew

  log_success "Homebrew installation verified."
}

main "$@"
