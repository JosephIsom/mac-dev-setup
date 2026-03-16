# shellcheck shell=bash
# shellcheck disable=SC2034
# mac-dev-setup managed Powerlevel10k config
typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
