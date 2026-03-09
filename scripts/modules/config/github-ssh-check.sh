#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists ssh || die "ssh command not found."

  log_info "Checking GitHub SSH connectivity..."
  set +e
  ssh -T git@github.com
  status=$?
  set -e

  case "$status" in
    1)
      log_success "GitHub SSH appears reachable. Exit code 1 is normal for successful auth test."
      ;;
    255)
      log_warn "GitHub SSH check failed. Ensure your SSH key is added to GitHub and agent/keychain is configured."
      ;;
    *)
      log_warn "GitHub SSH returned exit code $status. Review the output above."
      ;;
  esac
}

main "$@"
