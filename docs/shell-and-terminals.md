# Shell And Terminals

This page covers shell-facing modules: command-line tools, shell prompts, tmux, and terminal apps.

## Core Shell And CLI Modules

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `shell/cli/github/github-cli.sh` | On | Installs GitHub CLI, SSH-based Git protocol, and completion. | Use `gh auth login`, `gh repo clone`, `gh pr checkout`, `gh auth status`. | [GitHub CLI](https://cli.github.com/), [Manual](https://cli.github.com/manual/) | Authenticate with `gh auth login`. |
| `shell/cli/fzf/fzf.sh` | On | Adds fuzzy finding in shell workflows. | Use `fzf` directly or through tools that integrate with it. | [fzf](https://github.com/junegunn/fzf) | None. |
| `shell/cli/git-fzf/git-fzf.sh` | On | Adds `forgit`-style fuzzy Git helpers. | Use interactive Git helpers such as add, branch, or log pickers from the shell. | [forgit](https://github.com/wfxr/forgit) | None. |
| `shell/cli/zoxide/zoxide.sh` | On | Smarter directory jumping. | Use `z <partial-name>` after visiting a few directories. | [zoxide](https://github.com/ajeetdsouza/zoxide) | None. |
| `shell/cli/eza/eza.sh` | On | Modern `ls` replacement with icons and tree views. | Use the shell aliases `ls`, `ll`, `la`, `lt`. | [eza](https://github.com/eza-community/eza) | None. |
| `shell/cli/bat/bat.sh` | On | Better `cat` with syntax highlighting and paging. | Run `bat <file>`. | [bat](https://github.com/sharkdp/bat) | None. |
| `shell/cli/ripgrep/ripgrep.sh` | On | Fast code search. | Run `rg pattern`. | [ripgrep](https://github.com/BurntSushi/ripgrep) | None. |
| `shell/cli/fd/fd.sh` | On | Faster, nicer `find`. | Run `fd name`. | [fd](https://github.com/sharkdp/fd) | None. |
| `shell/cli/jq/jq.sh` | On | JSON query and transformation tool. | Run `jq` in pipelines for APIs and config files. | [jq](https://jqlang.org/) | None. |
| `shell/cli/yq/yq.sh` | On | YAML/JSON query tool. | Run `yq` for YAML, JSON, and TOML extraction. | [yq](https://github.com/mikefarah/yq) | None. |
| `shell/cli/direnv/direnv.sh` | On | Per-directory environment loading. | Create `.envrc`, then run `direnv allow`. | [direnv](https://direnv.net/) | Review `.envrc` files before allowing them. |
| `shell/cli/tree/tree.sh` | On | Directory tree output. | Run `tree`. | [tree](https://formulae.brew.sh/formula/tree) | None. |
| `shell/cli/wget/wget.sh` | On | Non-browser downloads and mirroring. | Run `wget <url>`. | [GNU Wget](https://www.gnu.org/software/wget/) | None. |
| `shell/cli/tldr/tldr.sh` | On | Practical command examples. | Run `tldr git`, `tldr docker`, and similar. | [tldr pages](https://tldr.sh/) | None. |
| `shell/cli/bottom/bottom.sh` | On | Modern process monitor. | Run `btm`. | [bottom](https://github.com/ClementTsang/bottom) | None. |
| `shell/cli/lazygit/lazygit.sh` | On | Full-screen Git TUI. | Run `lazygit` inside a repo. | [lazygit](https://github.com/jesseduffield/lazygit) | None. |
| `shell/cli/lazydocker/lazydocker.sh` | On | Docker and container TUI. | Run `lazydocker`. | [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker/Colima must already be working. |
| `shell/cli/jwt-cli/jwt-cli.sh` | On | JWT inspection and decoding. | Run `jwt decode <token>`. | [jwt-cli](https://github.com/mike-engel/jwt-cli) | None. |
| `shell/cli/delta/delta.sh` | On | Better diffs in Git and the shell. | Git uses it automatically after prerequisites complete. | [delta](https://github.com/dandavison/delta) | None. |
| `shell/cli/watch/watch.sh` | On | Repeat a command on an interval. | Run `watch -n 2 command`. | [watch](https://formulae.brew.sh/formula/watch) | None. |
| `shell/cli/curl/curl.sh` | On | Homebrew `curl` and PATH management. | Use `curl` for APIs, installers, and downloads. | [curl](https://curl.se/) | None. |
| `shell/cli/httpie/httpie.sh` | On | Friendly HTTP CLI client. | Use `http` for REST and API debugging. | [HTTPie CLI](https://httpie.io/cli) | None. |
| `shell/cli/make/make.sh` | On | GNU Make on macOS with path helpers. | Use `make` or `gmake` depending the project. | [GNU Make](https://www.gnu.org/software/make/) | None. |
| `shell/cli/cmake/cmake.sh` | On | C/C++ and cross-platform build configuration. | Use `cmake` and `ctest` in native projects. | [CMake](https://cmake.org/) | None. |
| `shell/cli/premake/premake.sh` | On | Alternative project generator/build scripting tool. | Use `premake` / `premake5` if your project relies on it. | [Premake](https://premake.github.io/) | None. |

## Tmux And Prompts

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `shell/tmux/tmux.sh` | On | Installs tmux config with a local override file. | Run `tmux`; customize `~/.tmux.local.conf` if needed. | [tmux](https://github.com/tmux/tmux), [Wiki](https://github.com/tmux/tmux/wiki) | Edit the local override instead of the managed base. |
| `shell/prompt/p10k/p10k.sh` | Optional | Powerlevel10k prompt. | Enable the module in bootstrap and open a new shell. | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Optional. |
| `shell/prompt/pure/pure.sh` | Optional | Minimal Pure prompt. | Enable the module and reopen the shell. | [Pure](https://github.com/sindresorhus/pure) | Optional. |
| `shell/prompt/starship/starship.sh` | Optional | Cross-shell prompt. | Enable the module and edit `~/.config/starship.toml` if desired. | [Starship](https://starship.rs/) | Optional. |
| `shell/prompt/oh-my-posh/oh-my-posh.sh` | Optional | Prompt engine with theme support. | Enable it if you prefer Oh My Posh over the other prompt options. | [Oh My Posh](https://ohmyposh.dev/) | Optional. |

## Terminal Apps

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `terminals/iterm2/iterm2-app.sh` | On | Installs iTerm2 and a managed dynamic profile. | Open iTerm2 and choose the `mac-dev-setup` profile. | [iTerm2](https://iterm2.com/) | Set the managed profile as your default profile if you want the repo’s font and behavior. |
| `terminals/ghostty/ghostty-app.sh` | On | Installs Ghostty and a managed config plus `local.conf`. | Launch Ghostty; edit `~/.config/ghostty/local.conf` for personal overrides. | [Ghostty](https://ghostty.org/), [Docs](https://ghostty.org/docs) | Keep local changes in `local.conf`. |
| `terminals/wezterm/wezterm-app.sh` | On | Installs WezTerm and a managed `wezterm.lua` plus local override. | Launch WezTerm; edit `~/.config/wezterm/local.lua` for personal overrides. | [WezTerm](https://wezfurlong.org/wezterm/) | Keep local changes in `local.lua`. |
| `terminals/warp/warp-app.sh` | On | Installs Warp and managed Apple Graphite Expanded light/dark theme files. | Launch Warp, pick the matching installed theme, and set the font. | [Warp](https://www.warp.dev/) | In the app, choose the Apple Graphite Expanded light or dark theme that matches macOS, then set `JetBrainsMono Nerd Font` size 14. |

## Notes On Shell Integration

Most CLI modules also install one or more of:

- Zsh completion scripts in `~/.zsh/plugins`
- aliases or PATH helpers
- VS Code or Neovim assets when the tool has editor relevance

That means enabling a module usually gives you both the binary and the shell/editor integration that goes with it.
