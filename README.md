# mac-dev-setup

`mac-dev-setup` bootstraps a new Mac for software development with a curated command-line environment, editor setup, language runtimes, cloud and container tooling, and optional desktop apps.

It also includes an optional `local-edge/` capability for a host-installed Caddy front door, local HTTPS, `.localhost` routing, and kind ingress bridging. That flow is separate from the main bootstrap on purpose.

The repo is meant to be:

- rerunnable
- easy to customize by commenting modules in `scripts/bootstrap.sh`
- friendly to both terminal-first and IDE-first workflows
- usable as a practical starting point for a brand new development machine

## What This Sets Up

- macOS defaults for Finder, Dock, input, and screenshots
- core prerequisites: Xcode Command Line Tools, Homebrew, fonts, Git, `mise`, SSH, and Zsh
- shell tooling and terminal apps
- language runtimes and common formatters, linters, LSPs, and editor integrations
- cloud, container, Kubernetes, and infrastructure tooling
- host-installed Caddy as an installable module for optional local edge/proxy work
- VS Code, IntelliJ Toolbox, Cursor, Windsurf, Neovim, and other optional editors
- AI CLIs and desktop apps
- optional desktop apps such as browsers, SQL clients, REST clients, secrets managers, and remote-access tools

## Quick Start

1. Clone the repo.
2. Copy `config/user.env.example` to `config/user.env`.
3. Set your Git identity and any runtime/version overrides you want in `config/user.env`.
4. Open [scripts/bootstrap.sh](/Users/joe/src/personal/mac-dev-setup/scripts/bootstrap.sh) and comment out anything you do not want installed.
5. Run bootstrap.
6. Run verify.
7. Complete the small number of manual sign-in or first-launch steps called out in the docs.

```bash
./scripts/bootstrap.sh
./scripts/verify.sh
```

## Optional Local Edge

The main bootstrap installs tools and prerequisites, including the `caddy` module. It does not configure or start the local edge stack.

Use the separate entrypoint when you explicitly want the local laptop edge setup:

```bash
./scripts/bootstrap-local-edge.sh setup
```

That opt-in flow is the only path that provisions the managed local-edge config. It stages the managed Caddy and kind config, validates the Caddyfile, and prints the next commands for starting Caddy, trusting the local CA, creating the kind cluster, and running the examples.

After `setup`, the other `bootstrap-local-edge` commands operate on the managed local-edge environment. The main bootstrap never invokes that provisioning flow.

## How Customization Works

- `scripts/prerequisites/prerequisites.sh` always runs the base machine setup.
- `scripts/bootstrap.sh` is the main install list.
- Uncommented `run_script_path` lines are enabled.
- Commented lines are optional.
- `scripts/verify.sh` should be kept in sync with your enabled modules.

## Read These Next

- [Getting Started](docs/getting-started.md)
- [Prerequisites](docs/prerequisites.md)
- [Shell And Terminals](docs/shell-and-terminals.md)
- [Runtimes And Tooling](docs/runtimes-and-tooling.md)
- [Cloud, Containers, And Infra](docs/cloud-containers-and-infra.md)
- [Local Edge](docs/local-edge.md)
- [Editors And AI](docs/editors-and-ai.md)
- [Desktop Apps And Services](docs/desktop-apps-and-services.md)
- [Post-Bootstrap Tasks](docs/post-bootstrap.md)

## What You Usually Edit

- [config/user.env.example](/Users/joe/src/personal/mac-dev-setup/config/user.env.example)
- [config/user.env](/Users/joe/src/personal/mac-dev-setup/config/user.env)
- [scripts/bootstrap.sh](/Users/joe/src/personal/mac-dev-setup/scripts/bootstrap.sh)
- [scripts/verify.sh](/Users/joe/src/personal/mac-dev-setup/scripts/verify.sh)

## Verification

Use:

```bash
./scripts/verify.sh
```

This checks the managed shell config, installed tools, language runtimes, editor assets, desktop apps, and other files that bootstrap is expected to create.

## Scope

This documentation focuses on how to use the repo:

- what each prerequisite or module installs
- why it is included
- how to use it after bootstrap
- which follow-up manual steps are still needed

It intentionally does not go deep on design history or internal architecture.
