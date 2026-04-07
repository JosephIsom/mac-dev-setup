# shellcheck shell=bash
# Sublime Text CLI path
if [[ -d "/Applications/Sublime Text.app/Contents/SharedSupport/bin" ]]; then
  export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
fi
