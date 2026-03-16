#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_TASK_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/files/taskfile/task-completion.zsh"
TARGET_TASK_ZSH_PLUGIN="$HOME/.zsh/plugins/task-completion.zsh"

install_task_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_TASK_ZSH_PLUGIN" "$(basename "$TARGET_TASK_ZSH_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "go-task" "task" "Task" --version
  install_task_zsh_plugin
  run_in_login_zsh 'task --completion zsh >/dev/null'
  [[ -f "$TARGET_TASK_ZSH_PLUGIN" ]] || die "Task zsh completion plugin not found at $TARGET_TASK_ZSH_PLUGIN"
}

main "$@"
