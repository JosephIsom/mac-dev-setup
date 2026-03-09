#!/usr/bin/env bash
set -euo pipefail

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() {
  printf '[PASS] %s\n' "$1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
  printf '[WARN] %s\n' "$1"
  WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
  printf '[FAIL] %s\n' "$1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_cmd() {
  local cmd="$1"
  local label="$2"
  if zsh -i -c "command -v $cmd >/dev/null 2>&1"; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_file() {
  local path="$1"
  local label="$2"
  if [[ -e "$path" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_optional_cmd() {
  local cmd="$1"
  local label="$2"
  if zsh -i -c "command -v $cmd >/dev/null 2>&1"; then
    pass "$label"
  else
    warn "$label"
  fi
}

printf '\n'
printf '========================================\n'
printf 'mac-dev-setup verify\n'
printf '========================================\n'
printf '\n'

check_cmd brew "Homebrew available"
check_cmd git "Git available"
check_cmd gh "GitHub CLI available"
check_cmd mise "mise available"

check_cmd python "Python available"
check_cmd uv "uv available"
check_cmd node "Node available"
check_cmd npm "npm available"
check_cmd pnpm "pnpm available"
check_cmd go "Go available"
check_cmd java "Java available"
check_optional_cmd mvn "Maven available"
check_optional_cmd gradle "Gradle available"

check_cmd colima "Colima available"
check_cmd docker "Docker CLI available"

if colima status 2>&1 | grep -qi 'running'; then
  pass "Colima running"
else
  warn "Colima running"
fi

if docker info >/dev/null 2>&1; then
  pass "Docker daemon reachable"
else
  warn "Docker daemon reachable"
fi

check_optional_cmd tmux "tmux available"
check_optional_cmd nvim "Neovim available"
check_optional_cmd code "VS Code CLI available"
check_optional_cmd idea "IntelliJ CLI helper available"

check_file "$HOME/.config/dev-bootstrap/zsh/bootstrap.zsh" "Managed zsh bootstrap present"
check_file "$HOME/.config/dev-bootstrap/tmux/tmux.conf" "Managed tmux config present"
check_file "$HOME/.config/dev-bootstrap/nvim/plugin/bootstrap.vim" "Managed Neovim bootstrap present"
check_file "$HOME/.ssh/config" "SSH config present"

printf '\n'
printf 'Summary: %s pass, %s warn, %s fail\n' "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT"

if [[ "$FAIL_COUNT" -gt 0 ]]; then
  exit 1
fi
