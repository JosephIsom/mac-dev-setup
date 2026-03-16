#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_AWS_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/cloud/aws/aws-completion.zsh"
TARGET_AWS_ZSH_PLUGIN="$HOME/.zsh/plugins/aws-completion.zsh"
REPO_AWS_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/cloud/aws/aws-vscode-extensions.txt"
TARGET_AWS_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/aws-vscode-extensions.txt"

install_aws_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_AWS_ZSH_PLUGIN" "$(basename "$TARGET_AWS_ZSH_PLUGIN")" >/dev/null
}

install_aws_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_AWS_VSCODE_EXTENSIONS" "$(basename "$TARGET_AWS_VSCODE_EXTENSIONS")" >/dev/null
}

verify_awscli() {
  brew_install_and_verify_command "awscli" "aws" "AWS CLI" --version

  command_exists aws_completer || die "aws_completer command not found after AWS CLI installation."
  [[ -f "$TARGET_AWS_ZSH_PLUGIN" ]] || die "AWS CLI zsh completion plugin not found at $TARGET_AWS_ZSH_PLUGIN."

  log_info "Verifying AWS CLI zsh integration..."
  run_in_login_zsh 'command -v aws >/dev/null 2>&1'
  run_in_login_zsh 'command -v aws_completer >/dev/null 2>&1'
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/aws-completion.zsh\" ]]"
  run_in_login_zsh 'complete -p aws 2>/dev/null | grep -F "aws_completer" >/dev/null'

  log_success "AWS CLI installation verified."
}

main() {
  install_aws_zsh_plugin
  install_aws_vscode_extensions
  verify_awscli
  [[ -f "$TARGET_AWS_VSCODE_EXTENSIONS" ]] || die "AWS VS Code extensions manifest not found at $TARGET_AWS_VSCODE_EXTENSIONS"
}

main "$@"
