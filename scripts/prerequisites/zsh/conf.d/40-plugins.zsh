# shellcheck shell=bash
# shellcheck disable=SC1090
# Plugins (mac-dev-setup)
# Ordering convention:
# 00-49: core prerequisites and shared shell UX
# 50-79: module-owned tool plugins and completions
# 80-89: prompt loader
# 90-99: finalizers, highlighting, and last-loaded integrations
if [[ -d "$HOME/.zsh/plugins" ]]; then
  typeset plugin_file
  setopt local_options null_glob

  for plugin_file in "$HOME/.zsh/plugins/"[0-4][0-9]-*.zsh; do
    source "$plugin_file"
  done

  for plugin_file in "$HOME/.zsh/plugins/"*.zsh; do
    case "$(basename "$plugin_file")" in
      [0-4][0-9]-*|[8-9][0-9]-*|zz*)
        continue
        ;;
    esac
    source "$plugin_file"
  done

  for plugin_file in "$HOME/.zsh/plugins/"[8-9][0-9]-*.zsh "$HOME/.zsh/plugins/"zz*.zsh; do
    source "$plugin_file"
  done
fi
