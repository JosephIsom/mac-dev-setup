#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BREW_DOCTOR_IGNORE_PATTERNS=(
  'unknown or unsupported macOS version'
)

run_brew() {
  if command -v brew >/dev/null 2>&1; then
    brew "$@"
    return
  fi

  local brew_bin
  brew_bin="$(brew_bin_path 2>/dev/null)" || die "brew command not found."
  "$brew_bin" "$@"
}

ensure_brew_shellenv_loaded() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  local brew_bin
  if brew_bin="$(brew_bin_path 2>/dev/null)"; then
    eval "$("$brew_bin" shellenv)"
  fi

  command -v brew >/dev/null 2>&1 || die "brew command not found after installation."
}

install_homebrew_if_missing() {
  if command -v brew >/dev/null 2>&1 || brew_bin_path >/dev/null 2>&1; then
    log_success "Homebrew already installed: $(brew_bin_path 2>/dev/null || command -v brew)"
    ensure_brew_shellenv_loaded
    return 0
  fi

  log_info "Installing Homebrew using the official install script..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_shellenv_loaded
  log_success "Homebrew installation completed."
}

update_homebrew() {
  log_info "Updating Homebrew..."
  local update_output="" update_status=0
  update_output="$(run_brew update 2>&1)" || update_status=$?

  printf '%s
' "$update_output"

  if [[ "$update_status" -ne 0 ]]; then
    if grep -qi 'unknown or unsupported macOS version' <<<"$update_output"; then
      log_warn "brew update hit a macOS version support issue. Continuing with the installed Homebrew."
    else
      die "brew update failed."
    fi
  fi

  log_success "Homebrew update step completed."
}

doctor_homebrew() {
  log_info "Running brew doctor..."
  local doctor_output="" doctor_status=0 ignore_pattern ignored="false"
  doctor_output="$(run_brew doctor 2>&1)" || doctor_status=$?

  printf '%s
' "$doctor_output"

  if [[ "$doctor_status" -eq 0 ]]; then
    log_success "brew doctor passed."
    return 0
  fi

  for ignore_pattern in "${BREW_DOCTOR_IGNORE_PATTERNS[@]}"; do
    if grep -qi "$ignore_pattern" <<<"$doctor_output"; then
      ignored="true"
      break
    fi
  done

  if [[ "$ignored" == "true" ]]; then
    log_warn "brew doctor reported a known ignorable issue on this macOS version. Continuing."
    return 0
  fi

  die "brew doctor reported issues that require attention."
}

main() {
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
