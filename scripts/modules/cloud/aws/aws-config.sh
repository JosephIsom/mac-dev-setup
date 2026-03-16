#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

AWS_DIR="$HOME/.aws"
REPO_AWS_CONFIG="$REPO_ROOT/scripts/modules/cloud/aws/assets/config"
REPO_AWS_CREDENTIALS="$REPO_ROOT/scripts/modules/cloud/aws/assets/credentials"
TARGET_AWS_CONFIG="$AWS_DIR/config"
TARGET_AWS_CREDENTIALS="$AWS_DIR/credentials"

install_if_missing() {
  local src="$1"
  local dest="$2"
  local label="$3"

  [[ -f "$src" ]] || die "Missing repo-managed AWS file: $src"

  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $label at $dest"
    return 0
  fi

  cp "$src" "$dest"
  chmod 600 "$dest"
  log_success "Installed $label at $dest"
}

verify_aws_config() {
  [[ -d "$AWS_DIR" ]] || die "AWS config directory not found at $AWS_DIR."
  [[ -f "$TARGET_AWS_CONFIG" ]] || die "AWS config file not found at $TARGET_AWS_CONFIG."
  [[ -f "$TARGET_AWS_CREDENTIALS" ]] || die "AWS credentials file not found at $TARGET_AWS_CREDENTIALS."
  log_success "AWS CLI config verified ($AWS_DIR)."
}

main() {
  mkdir -p "$AWS_DIR"
  chmod 700 "$AWS_DIR"

  install_if_missing "$REPO_AWS_CONFIG" "$TARGET_AWS_CONFIG" "AWS config"
  install_if_missing "$REPO_AWS_CREDENTIALS" "$TARGET_AWS_CREDENTIALS" "AWS credentials"
  verify_aws_config
}

main "$@"
