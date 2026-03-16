# Prerequisites

These scripts always run through [scripts/prerequisites/prerequisites.sh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/prerequisites.sh).

## Always-On Prerequisites

| Script | What it does | Why it is included | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `scripts/prerequisites/xcode/xcode-clt.sh` | Installs Xcode Command Line Tools. | Many Homebrew packages, compilers, and developer workflows depend on Apple’s CLI toolchain. | You usually do not use this directly after setup; it is a foundation for compilers and Apple SDK headers. | [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/) | None unless macOS prompts for extra license acceptance. |
| `scripts/prerequisites/homebrew/homebrew.sh` | Installs Homebrew and base package-management setup. | Most modules install formulae or casks through Homebrew. | Use `brew install`, `brew upgrade`, and `brew info` after bootstrap. | [Homebrew](https://brew.sh/) | None. |
| `scripts/prerequisites/fonts/fonts.sh` | Installs the repo’s baseline fonts, including Nerd Fonts. | Terminals, prompts, and themes depend on consistent fonts. | Select these fonts inside your terminal/editor preferences. | [Homebrew Fonts](https://github.com/Homebrew/homebrew-cask-fonts) | Pick `JetBrainsMono Nerd Font` in terminals that do not have a file-based default. |
| `scripts/prerequisites/git/git.sh` | Configures Git identity, global ignore rules, credential storage, and baseline aliases. | Git is core to almost every development workflow. | Run `git config --global --list` to inspect settings; use the aliases in your shell. | [Git](https://git-scm.com/), [Git Book](https://git-scm.com/book/en/v2) | Set `GIT_USER_NAME` and `GIT_USER_EMAIL` in `config/user.env`. |
| `scripts/prerequisites/mise/mise.sh` | Installs and configures `mise` for runtime/version management. | The repo uses `mise` to install and select language runtimes. | Run `mise list`, `mise current`, and `mise use -g` when you want to inspect or change versions. | [mise](https://mise.jdx.dev/) | Set runtime versions in `config/user.env` before bootstrap if you want something other than the defaults. |
| `scripts/prerequisites/ssh/ssh.sh` | Installs the managed SSH config. | SSH is needed for GitHub, private Git remotes, and other infrastructure access. | Put host-specific additions under `~/.ssh/config.d` if needed. | [OpenSSH](https://www.openssh.com/), [ssh_config](https://man.openbsd.org/ssh_config) | Your private keys still need to exist in `~/.ssh`. |
| `scripts/prerequisites/zsh/zsh.sh` | Installs the managed Zsh bootstrap, core config, and shared vendor plugins. | Zsh is the default interactive shell baseline for the machine. | Open a new terminal window after bootstrap; your shell config loads from the managed files under `~/.zsh`. | [Zsh](https://www.zsh.org/), [Zsh Guide](https://zsh.sourceforge.io/Guide/zshguide.html) | Use `~/.zsh/conf.d/90-local.zsh` for machine-local additions. |

## Git Baseline

The Git prerequisite sets a practical default machine config:

- native macOS credential storage via Keychain
- `delta` as the Git pager when available
- safer merge conflict rendering
- global ignores for common local-only files

Useful shell aliases live in [scripts/prerequisites/git/git-aliases.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/git/git-aliases.zsh), including `gs`, `gsw`, `gswc`, `grs`, and `gc`.

## Zsh Baseline

The Zsh prerequisite installs:

- managed `~/.zshrc` and `~/.zprofile`
- core aliases, functions, keybindings, and completion policy
- vendor plugins for completions, `fzf-tab`, autosuggestions, and syntax highlighting

Important files:

- [scripts/prerequisites/zsh/conf.d/00-path.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/00-path.zsh)
- [scripts/prerequisites/zsh/conf.d/10-aliases.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/10-aliases.zsh)
- [scripts/prerequisites/zsh/conf.d/15-functions.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/15-functions.zsh)
- [scripts/prerequisites/zsh/conf.d/20-bindings.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/20-bindings.zsh)
- [scripts/prerequisites/zsh/conf.d/30-completion.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/30-completion.zsh)
- [scripts/prerequisites/zsh/conf.d/90-local.zsh](/Users/joe/src/personal/mac-dev-setup/scripts/prerequisites/zsh/conf.d/90-local.zsh)

## User Config Values

The main configuration surface is [config/user.env.example](/Users/joe/src/personal/mac-dev-setup/config/user.env.example):

- Git identity
- Colima resources
- runtime versions for Python, Node, Go, Java, Groovy, Lua, Rust, Bun, .NET, Ruby, PHP, Kotlin, and Zig

Create `config/user.env` and keep your real values there.
