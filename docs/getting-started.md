# Getting Started

## Before You Run Anything

- You need a macOS machine with an admin account.
- The repo assumes macOS and will stop on other operating systems.
- Bootstrap installs and configures software in your home directory and `/Applications`.
- Many optional tools are disabled simply by commenting their line in `scripts/bootstrap.sh`.

## 1. Clone The Repo

```bash
git clone <your-fork-or-copy-url>
cd mac-dev-setup
```

## 2. Create Your User Config

Copy the example file:

```bash
cp config/user.env.example config/user.env
```

Edit [config/user.env.example](/Users/joe/src/personal/mac-dev-setup/config/user.env.example) values in your real `config/user.env`:

- `GIT_USER_NAME`
- `GIT_USER_EMAIL`
- `COLIMA_CPU`
- `COLIMA_MEMORY`
- `COLIMA_DISK`
- runtime versions such as `PYTHON_VERSION`, `NODE_VERSION`, `GO_VERSION`, `JAVA_VERSION`
- optional local-edge overrides such as `LOCAL_EDGE_KIND_CLUSTER_NAME` and the ingress ports if you want to change them before running local-edge setup

`mise` uses these values when installing runtimes.

## 3. Choose What To Install

Open [scripts/bootstrap.sh](/Users/joe/src/personal/mac-dev-setup/scripts/bootstrap.sh).

- Leave uncommented lines enabled.
- Comment out anything you do not want.
- Most optional modules are already commented out.

Then open [scripts/verify.sh](/Users/joe/src/personal/mac-dev-setup/scripts/verify.sh) and comment out checks that do not match your enabled module list.

## 4. Run Bootstrap

```bash
./scripts/bootstrap.sh
```

Bootstrap does three main things:

1. Runs the base prerequisites.
2. Runs each enabled module in order.
3. Stages or writes managed config files for Zsh, Neovim, VS Code, terminals, and related tools.

It now also installs the `caddy` binary through the normal modules list, but it still does not configure the optional local edge stack for you.

## 5. Run Verification

```bash
./scripts/verify.sh
```

If verify fails:

- confirm the matching module is still enabled in `scripts/bootstrap.sh`
- re-run the module directly if needed
- complete any required sign-in or first-launch step
- run verify again

## 6. Re-Run A Single Module

Every module is just a shell script. You can run one directly:

```bash
bash scripts/modules/runtimes/python/python-runtime.sh
bash scripts/modules/editors/vscode/extensions.sh
```

This is the fastest way to recover after enabling a new module or fixing a failed install.

## 7. Understand The Managed Config Model

The repo owns baseline config for:

- Zsh
- some terminal apps
- Neovim
- VS Code settings, extensions, and reusable templates

Common pattern:

- the repo installs a managed baseline
- it preserves or backs up unmanaged files where the module supports that
- it leaves a local override file in place when that tool benefits from one

Examples:

- Ghostty keeps `~/.config/ghostty/local.conf`
- WezTerm keeps `~/.config/wezterm/local.lua`
- Neovim keeps `~/.config/nvim/lua/mac_dev_setup/local.lua`

## 8. Know The Main Follow-Up Tasks

After bootstrap, common manual steps are:

- `gh auth login`
- open JetBrains Toolbox and install IntelliJ IDEA
- open Zed and run `cli: install`
- open Android Studio and complete the SDK setup wizard
- sign in to 1Password or Bitwarden if you enabled them
- sign in to Tailscale or ngrok if you enabled them
- pick `Islands Dark (mac-dev-setup)` and the managed font if you enabled Warp

The complete list is in [Post-Bootstrap Tasks](post-bootstrap.md).

## Optional: Set Up Local Edge

If you want a local HTTPS front door with `.localhost` hostnames, host-installed Caddy, and kind ingress routing, run the dedicated opt-in entrypoint after bootstrap:

```bash
./scripts/bootstrap-local-edge.sh setup
```

That flow lives under [`local-edge/`](/Users/joe/src/personal/mac-dev-setup/local-edge) and is intentionally separate from the base machine bootstrap. It is also the only command path that provisions the managed Caddyfile link, local-edge config files, and kind edge config. Other `bootstrap-local-edge` subcommands expect setup to have already been completed.
