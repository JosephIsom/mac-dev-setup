# shellcheck shell=bash
# Homebrew LLVM PATH wiring (mac-dev-setup)
if [[ -d /opt/homebrew/opt/llvm/bin ]]; then
  path=("${path[@]}" /opt/homebrew/opt/llvm/bin)
elif [[ -d /usr/local/opt/llvm/bin ]]; then
  path=("${path[@]}" /usr/local/opt/llvm/bin)
fi
