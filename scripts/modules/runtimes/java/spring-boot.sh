#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SPRING_BOOT_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/java/spring-boot-completion.zsh"
TARGET_SPRING_BOOT_ZSH_PLUGIN="$HOME/.zsh/plugins/spring-boot-completion.zsh"

install_spring_boot_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_SPRING_BOOT_ZSH_PLUGIN" "$(basename "$TARGET_SPRING_BOOT_ZSH_PLUGIN")" >/dev/null
}

main() {
  brew_ensure_tap "spring-io/tap"
  brew_install_formula "spring-boot"
  install_spring_boot_zsh_plugin

  command_exists spring || die "spring command not found after installation."

  log_info "Verifying Spring Boot CLI..."
  spring --version
  [[ -f "$TARGET_SPRING_BOOT_ZSH_PLUGIN" ]] || die "Spring Boot CLI zsh completion plugin not found at $TARGET_SPRING_BOOT_ZSH_PLUGIN"

  log_success "Spring Boot CLI installation verified."
}

main "$@"
