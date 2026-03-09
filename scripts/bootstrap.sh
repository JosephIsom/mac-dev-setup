#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"

source "$LIB_DIR/common.sh"
source "$LIB_DIR/selection.sh"

export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR

main() {
  ensure_macos
  init_defaults
  parse_args "$@"
  resolve_selection
  export GIT_USER_NAME GIT_USER_EMAIL GITHUB_GIT_PROTOCOL
  export PYTHON_VERSION NODE_VERSION GO_VERSION JAVA_VERSION
  export COLIMA_CPU COLIMA_MEMORY COLIMA_DISK
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

  run_if_selected "INSTALL_CORE_XCODE_CLT"             "core"      "xcode-clt"
  run_if_selected "INSTALL_CORE_HOMEBREW"              "core"      "homebrew"
  run_if_selected "INSTALL_CORE_GIT"                   "core"      "git"
  run_if_selected "INSTALL_CORE_GITHUB_CLI"            "core"      "github-cli"
  run_if_selected "INSTALL_CORE_CHEZMOI"               "core"      "chezmoi"
  run_if_selected "INSTALL_CORE_MISE"                  "core"      "mise"
  run_if_selected "INSTALL_CORE_BREWFILE_APPLY"        "core"      "brewfile-apply"
  run_if_selected "INSTALL_CORE_BREWFILE_EXPORT"       "core"      "brewfile-export"

  run_if_selected "INSTALL_CONFIG_GIT_BASELINE"        "config"    "git-baseline"
  run_if_selected "INSTALL_CONFIG_GITHUB_CLI_BASELINE" "config"    "github-cli-baseline"
  run_if_selected "INSTALL_CONFIG_SSH_BASELINE"        "config"    "ssh-baseline"
  run_if_selected "INSTALL_CONFIG_GITHUB_SSH_CHECK"    "config"    "github-ssh-check"

  run_if_selected "INSTALL_SHELL_ZSH_BASELINE"         "shell"     "zsh-baseline"
  run_if_selected "INSTALL_SHELL_COMPLETION_CORE"      "shell"     "completion-core"
  run_if_selected "INSTALL_SHELL_GIT_INTEGRATION"      "shell"     "git-integration"
  run_if_selected "INSTALL_SHELL_FZF"                  "shell"     "fzf"
  run_if_selected "INSTALL_SHELL_ZOXIDE"               "shell"     "zoxide"
  run_if_selected "INSTALL_SHELL_EZA"                  "shell"     "eza"
  run_if_selected "INSTALL_SHELL_BAT"                  "shell"     "bat"
  run_if_selected "INSTALL_SHELL_RIPGREP"              "shell"     "ripgrep"
  run_if_selected "INSTALL_SHELL_FD"                   "shell"     "fd"
  run_if_selected "INSTALL_SHELL_JQ"                   "shell"     "jq"
  run_if_selected "INSTALL_SHELL_YQ"                   "shell"     "yq"
  run_if_selected "INSTALL_SHELL_DIRENV"               "shell"     "direnv"
  run_if_selected "INSTALL_SHELL_TREE"                 "shell"     "tree"
  run_if_selected "INSTALL_SHELL_WGET"                 "shell"     "wget"
  run_if_selected "INSTALL_SHELL_TMUX"                 "shell"     "tmux"
  run_if_selected "INSTALL_SHELL_TMUX"                 "shell"     "tmux-baseline"

  run_if_selected "INSTALL_PYTHON_RUNTIME"             "runtime"   "python-runtime"
  run_if_selected "INSTALL_PYTHON_UV"                  "runtime"   "python-uv"
  run_if_selected "INSTALL_PYTHON_LINTERS"             "runtime"   "python-linters"
  run_if_selected "INSTALL_PYTHON_PRE_COMMIT"          "runtime"   "python-pre-commit"
  run_if_selected "INSTALL_NODE_RUNTIME"               "runtime"   "node-runtime"
  run_if_selected "INSTALL_NODE_PNPM"                  "runtime"   "node-pnpm"
  run_if_selected "INSTALL_NODE_TYPESCRIPT"            "runtime"   "node-typescript"
  run_if_selected "INSTALL_GO_RUNTIME"                 "runtime"   "go-runtime"
  run_if_selected "INSTALL_GO_DEV_TOOLS"               "runtime"   "go-dev-tools"
  run_if_selected "INSTALL_JAVA_RUNTIME"               "runtime"   "java-runtime"
  run_if_selected "INSTALL_JAVA_MAVEN"                 "runtime"   "java-maven"
  run_if_selected "INSTALL_JAVA_GRADLE"                "runtime"   "java-gradle"

  run_if_selected "INSTALL_CONTAINERS_COLIMA"          "container" "colima"
  run_if_selected "INSTALL_CONTAINERS_DOCKER_CLI"      "container" "docker-cli"
  run_if_selected "INSTALL_CONTAINERS_BUILDX"          "container" "buildx"
  run_if_selected "INSTALL_CONTAINERS_COMPOSE"         "container" "compose"
  run_if_selected "INSTALL_CONTAINERS_COLIMA"          "container" "colima-start"
  run_if_selected "INSTALL_CONTAINERS_DOCKER_CLI"      "container" "docker-verify"

  run_if_selected "INSTALL_QUALITY_SHELLCHECK"         "quality"   "shellcheck"
  run_if_selected "INSTALL_QUALITY_SHFMT"              "quality"   "shfmt"
  run_if_selected "INSTALL_QUALITY_MARKDOWNLINT"       "quality"   "markdownlint"
  run_if_selected "INSTALL_QUALITY_YAMLLINT"           "quality"   "yamllint"
  run_if_selected "INSTALL_QUALITY_ACTIONLINT"         "quality"   "actionlint"

  run_if_selected "INSTALL_EDITOR_VSCODE_APP"          "editor"    "vscode-app"
  run_if_selected "INSTALL_EDITOR_VSCODE_CLI"          "editor"    "vscode-cli"
  run_if_selected "INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE" "editor" "vscode-extensions-base"
  run_if_selected "INSTALL_EDITOR_VSCODE_SETTINGS_BASE"   "editor" "vscode-settings-base"
  run_if_selected "INSTALL_EDITOR_INTELLIJ_TOOLBOX"    "editor"    "intellij-toolbox"
  run_if_selected "INSTALL_EDITOR_INTELLIJ_IDEA"       "editor"    "intellij-idea"
  run_if_selected "INSTALL_EDITOR_INTELLIJ_CLI"        "editor"    "intellij-cli"
  run_if_selected "INSTALL_EDITOR_ITERM2_APP"          "editor"    "iterm2-app"
  run_if_selected "INSTALL_EDITOR_NEOVIM"              "editor"    "neovim"
  run_if_selected "INSTALL_EDITOR_NEOVIM"              "editor"    "neovim-toolchain"
}

main "$@"
