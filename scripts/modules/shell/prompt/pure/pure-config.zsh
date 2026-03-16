# shellcheck shell=bash
# shellcheck disable=SC2034
# mac-dev-setup managed Pure config
PURE_CMD_MAX_EXEC_TIME=10
PURE_GIT_PULL=1
PURE_GIT_UNTRACKED_DIRTY=1

zstyle ':prompt:pure:path' color cyan
zstyle ':prompt:pure:git:branch' color magenta
zstyle ':prompt:pure:prompt:*' color blue
zstyle ':prompt:pure:git:stash' show yes
