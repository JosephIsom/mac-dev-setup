if command -v terraform >/dev/null 2>&1; then
  autoload -Uz +X bashcompinit && bashcompinit
  complete -o nospace -C terraform terraform
fi
