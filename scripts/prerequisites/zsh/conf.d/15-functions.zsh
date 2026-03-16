# shellcheck shell=bash
# shellcheck disable=SC2154
# Core shell functions (mac-dev-setup)

# Create a directory and immediately enter it.
mkcd() {
  [[ $# -eq 1 ]] || {
    printf 'usage: mkcd <directory>\n' >&2
    return 1
  }

  mkdir -p -- "$1" && cd -- "$1" || return 1
}

# Move up N directories; defaults to one level.
up() {
  local levels="${1:-1}"

  [[ "$levels" =~ ^[0-9]+$ ]] || {
    printf 'usage: up [levels]\n' >&2
    return 1
  }

  while (( levels > 0 )); do
    cd .. || return 1
    ((levels--))
  done
}

# Print the current PATH as one entry per line.
pathshow() {
  printf '%s\n' "${path[@]}"
}

# Show the process currently listening on a local TCP port.
port() {
  [[ $# -eq 1 ]] || {
    printf 'usage: port <port-number>\n' >&2
    return 1
  }

  lsof -nP -iTCP:"$1" -sTCP:LISTEN
}
