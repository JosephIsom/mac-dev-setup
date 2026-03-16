#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

AWS_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/aws"

main() {
  run_script_path "$AWS_MODULES_DIR/awscli.sh"
  run_script_path "$AWS_MODULES_DIR/aws-config.sh"
  run_script_path "$AWS_MODULES_DIR/awscli-local.sh"
  run_script_path "$AWS_MODULES_DIR/okta-aws-cli.sh"
  run_script_path "$AWS_MODULES_DIR/aws-sso-cli.sh"
  run_script_path "$AWS_MODULES_DIR/aws-vault.sh"
  run_script_path "$AWS_MODULES_DIR/localstack.sh"
}

main "$@"
