# shellcheck shell=bash
# AWS CLI completion (mac-dev-setup)
if command -v aws_completer >/dev/null 2>&1; then
  if ! typeset -f complete >/dev/null 2>&1; then
    autoload -Uz +X bashcompinit
    bashcompinit
  fi

  complete -C "$(command -v aws_completer)" aws

  if command -v awslocal >/dev/null 2>&1; then
    complete -C "$(command -v aws_completer)" awslocal
  fi
fi
