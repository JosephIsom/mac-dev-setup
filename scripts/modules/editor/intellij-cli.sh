#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

TARGET_DIR="$HOME/.local/bin"
TARGET_LINK="$TARGET_DIR/idea"

find_toolbox_script() {
  find "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" \
       "$HOME/Library/Application Support/JetBrains/Toolbox" \
       -type f \( -name "idea" -o -name "idea.sh" -o -name "intellij-idea" \) 2>/dev/null | head -n 1
}

ensure_local_bin_in_path() {
  mkdir -p "$TARGET_DIR"

  if ! grep -Fq 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.config/dev-bootstrap/zsh/local.zsh" 2>/dev/null; then
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.config/dev-bootstrap/zsh/local.zsh"
    log_success "Added ~/.local/bin PATH entry to dev-bootstrap local.zsh"
  fi
}

main() {
  ensure_local_bin_in_path

  local toolbox_script=""
  toolbox_script="$(find_toolbox_script || true)"

  if [[ -z "$toolbox_script" ]]; then
    log_warn "No JetBrains Toolbox IntelliJ shell script found yet."
    log_warn "Open Toolbox, install IntelliJ IDEA, and enable/generated shell scripts first."
    exit 0
  fi

  ln -sf "$toolbox_script" "$TARGET_LINK"

  if ! run_in_login_zsh 'command -v idea >/dev/null 2>&1'; then
    die "idea command is not available in zsh after symlink setup."
  fi

  log_info "Verified IntelliJ CLI helper:"
  run_in_login_zsh 'command -v idea'

  log_success "IntelliJ CLI helper setup verified."
}

main "$@"
