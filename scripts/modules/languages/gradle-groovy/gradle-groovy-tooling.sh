#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GLS_WRAPPER="$REPO_ROOT/scripts/modules/languages/gradle-groovy/groovy-language-server"
REPO_GROOVY_LSP_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/gradle-groovy/gradle-groovy-neovim.lua"
TARGET_GLS_DIR="$HOME/.local/share/groovy-language-server"
TARGET_GLS_BIN_DIR="$HOME/.local/bin"
TARGET_GLS_BIN="$TARGET_GLS_BIN_DIR/groovy-language-server"
TARGET_GLS_JAR="$TARGET_GLS_DIR/build/libs/groovy-language-server-all.jar"
TARGET_GROOVY_LSP_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_gradle_groovy.lua"

install_wrapper() {
  [[ -f "$REPO_GLS_WRAPPER" ]] || die "Missing Groovy language server wrapper: $REPO_GLS_WRAPPER"

  mkdir -p "$TARGET_GLS_BIN_DIR"
  cp "$REPO_GLS_WRAPPER" "$TARGET_GLS_BIN"
  chmod 755 "$TARGET_GLS_BIN"
}

build_groovy_language_server() {
  command_exists git || die "git is required to install the Groovy language server."
  command_exists_in_zsh java || die "java must be available in zsh before Groovy language server support runs."

  # Upstream does not publish stable tags or release branches, so this module
  # intentionally builds from the default branch instead of pinning a ref.
  sync_git_checkout "https://github.com/GroovyLanguageServer/groovy-language-server.git" "$TARGET_GLS_DIR" "groovy-language-server"
  run_in_login_zsh "cd '$TARGET_GLS_DIR' && ./gradlew build"

  [[ -f "$TARGET_GLS_JAR" ]] || die "Groovy language server jar not found at $TARGET_GLS_JAR"
}

install_groovy_lsp_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_GROOVY_LSP_NVIM_PLUGIN" "$(basename "$TARGET_GROOVY_LSP_NVIM_PLUGIN")" >/dev/null
}

main() {
  build_groovy_language_server
  install_wrapper

  log_info "Verifying Gradle/Groovy authoring support..."
  run_in_login_zsh 'command -v groovy-language-server >/dev/null 2>&1'
  run_in_login_zsh 'groovy-language-server --help >/dev/null'
  install_groovy_lsp_neovim_plugin
  [[ -f "$TARGET_GROOVY_LSP_NVIM_PLUGIN" ]] || die "Gradle/Groovy Neovim plugin spec not found at $TARGET_GROOVY_LSP_NVIM_PLUGIN"

  log_success "Gradle/Groovy authoring support verified."
}

main "$@"
