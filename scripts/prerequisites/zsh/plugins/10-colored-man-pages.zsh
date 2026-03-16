# shellcheck shell=bash
# colored man pages (mac-dev-setup)
if command -v tput >/dev/null 2>&1; then
  LESS_TERMCAP_mb="$(tput bold; tput setaf 3)"
  LESS_TERMCAP_md="$(tput bold; tput setaf 6)"
  LESS_TERMCAP_me="$(tput sgr0)"
  LESS_TERMCAP_se="$(tput sgr0)"
  LESS_TERMCAP_so="$(tput bold; tput setaf 2; tput setab 0)"
  LESS_TERMCAP_ue="$(tput sgr0)"
  LESS_TERMCAP_us="$(tput smul; tput bold; tput setaf 4)"
  export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se
  export LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us
fi
