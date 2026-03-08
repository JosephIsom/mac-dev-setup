#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"

export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR
export GIT_USER_NAME GIT_USER_EMAIL GITHUB_GIT_PROTOCOL

source "$LIB_DIR/common.sh"
source "$LIB_DIR/selection.sh"

main() {
  ensure_macos
  init_defaults
  parse_args "$@"
  resolve_selection
  export GIT_USER_NAME GIT_USER_EMAIL GITHUB_GIT_PROTOCOL
  print_banner
  print_selection_summary

  run_selected_modules

  log_success "Bootstrap phase completed."
}

run_if_selected() {
  local selection_var="$1"
  local group="$2"
  local name="$3"
  local value="${!selection_var:-false}"

  if bool_is_true "$value"; then
    run_module "$group" "$name"
  else
    log_info "Skipping module: $group/$name ($selection_var=false)"
  fi
}

run_selected_modules() {
  run_module "core" "repo-sanity"

  run_if_selected "INSTALL_CORE_XCODE_CLT"          "core"   "xcode-clt"
  run_if_selected "INSTALL_CORE_HOMEBREW"           "core"   "homebrew"
  run_if_selected "INSTALL_CORE_GIT"                "core"   "git"
  run_if_selected "INSTALL_CORE_GITHUB_CLI"         "core"   "github-cli"
  run_if_selected "INSTALL_CORE_CHEZMOI"            "core"   "chezmoi"

  run_if_selected "INSTALL_CONFIG_GIT_BASELINE"     "config" "git-baseline"
  run_if_selected "INSTALL_CONFIG_GITHUB_CLI_BASELINE" "config" "github-cli-baseline"

  run_if_selected "INSTALL_PYTHON_RUNTIME"          "core"   "mise"

  run_if_selected "INSTALL_SHELL_ZSH_BASELINE"      "shell"  "zsh-baseline"
  run_if_selected "INSTALL_SHELL_COMPLETION_CORE"   "shell"  "completion-core"
  run_if_selected "INSTALL_SHELL_GIT_INTEGRATION"   "shell"  "git-integration"
  run_if_selected "INSTALL_SHELL_FZF"               "shell"  "fzf"
  run_if_selected "INSTALL_SHELL_ZOXIDE"            "shell"  "zoxide"
  run_if_selected "INSTALL_SHELL_EZA"               "shell"  "eza"
  run_if_selected "INSTALL_SHELL_BAT"               "shell"  "bat"
  run_if_selected "INSTALL_SHELL_RIPGREP"           "shell"  "ripgrep"
  run_if_selected "INSTALL_SHELL_FD"                "shell"  "fd"
  run_if_selected "INSTALL_SHELL_JQ"                "shell"  "jq"
  run_if_selected "INSTALL_SHELL_YQ"                "shell"  "yq"
  run_if_selected "INSTALL_SHELL_DIRENV"            "shell"  "direnv"
  run_if_selected "INSTALL_SHELL_TREE"              "shell"  "tree"
  run_if_selected "INSTALL_SHELL_WGET"              "shell"  "wget"
  run_if_selected "INSTALL_SHELL_TMUX"              "shell"  "tmux"

  run_if_selected "INSTALL_EDITOR_ITERM2_APP"       "editor" "iterm2-app"
  run_if_selected "INSTALL_EDITOR_NEOVIM"           "editor" "neovim"
}

main "$@"