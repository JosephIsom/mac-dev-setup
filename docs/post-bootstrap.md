# Post-Bootstrap Tasks

These are the manual or first-launch steps still worth doing after the scripts finish.

## Core Setup

### GitHub CLI

The GitHub CLI module installs `gh`, sets Git protocol to SSH, and writes notes to `~/.config/gh/bootstrap-notes`.

Run:

```bash
gh auth login
gh auth status
```

## Editors

### JetBrains Toolbox And IntelliJ IDEA

After enabling the IntelliJ modules:

1. Open JetBrains Toolbox.
2. Sign in to your JetBrains account.
3. Install IntelliJ IDEA from Toolbox.
4. Optionally enable Toolbox shell scripts so `idea` launchers are generated.

If you also enabled IntelliJ AI notes:

1. Open IntelliJ IDEA.
2. Install JetBrains AI Assistant.
3. Add Junie if you want it.
4. Install Gemini Code Assist from the plugin marketplace if desired.

### Zed

Zed’s CLI is installed from inside the app on macOS:

1. Open Zed.
2. Open the command palette with `Cmd+Shift+P`.
3. Run `cli: install`.

Then open a new terminal and verify:

```bash
zed --version
```

### Android Studio

If you enabled Android Studio:

1. Open Android Studio.
2. Complete the Setup Wizard.
3. Install the Android SDK, platform tools, emulator, and system images you need.
4. Optionally use `Tools > Create Command-line Launcher` to install the `studio` launcher.

### Neovim

If you enabled Neovim:

- the baseline config is installed for you
- `lazy.nvim` is bootstrapped automatically
- the initial plugin sync runs during install

Use `~/.config/nvim/lua/mac_dev_setup/local.lua` for personal overrides.

## AI Tools

### Claude Code

Claude writes notes to `~/.config/claude/ide-notes.txt`.

Common flows:

- inside VS Code, Cursor, Windsurf, or VSCodium:
  - open the integrated terminal
  - run `claude`
  - Claude installs its editor integration the first time
- inside JetBrains:
  - open the integrated terminal
  - run `claude`
- from an external terminal:
  - use `/ide` to connect to your editor session

### Continue, Gemini, Copilot, Codex, And Other AI Tools

After enabling any AI module:

- sign in or configure the provider/tool as required
- open VS Code if the module staged extensions or settings
- re-run `scripts/modules/editors/vscode/extensions.sh` and `scripts/modules/editors/vscode/settings.sh` if you enabled the AI module after your first bootstrap

For GitHub Copilot in VS Code specifically:

1. Open VS Code.
2. Sign in to GitHub from inside VS Code if prompted.
3. Enable Copilot on the GitHub account you want to use.
4. Let VS Code finish installing or activating the Copilot extensions it needs.
5. Open the Copilot or Chat UI once to confirm it is active.

### Ollama And LM Studio

For local model workflows:

- install the module
- pull or download the models you want
- configure your editor/CLI tools to point at the local server if needed

## Secrets Managers

### 1Password

After enabling 1Password:

1. Sign in to the app.
2. Turn on Touch ID or system auth if desired.
3. Run `op signin` after the desktop app is ready.
4. If you want 1Password as your SSH agent, enable it from `Settings > Developer`.

Important: the repo already configures Apple Keychain support for standard OpenSSH. 1Password SSH agent is optional, not required.

### Bitwarden

After enabling Bitwarden:

1. Sign in to the app.
2. Run `bw login` or your preferred Bitwarden CLI auth flow.
3. Use `bw sync` once your session is valid.

## Remote Access

### Tailscale

After enabling Tailscale:

1. Open the app.
2. Sign in and complete onboarding.
3. Approve VPN/system-extension prompts.
4. Optionally run:

```bash
tailscale up
```

### ngrok

After enabling ngrok:

1. Sign in to ngrok.
2. Add your auth token:

```bash
ngrok config add-authtoken <token>
```

3. Start a tunnel, for example:

```bash
ngrok http 3000
```

## Containers

### Colima And Docker

Common first commands:

```bash
colima start
docker info
docker run hello-world
```

### Testcontainers Desktop

If you enabled Testcontainers Desktop:

1. Launch the app.
2. Sign in with Docker.
3. Choose the runtime you want Testcontainers to use.
4. Optionally enable the embedded runtime from the app if you want to try it.

## Terminal Apps

### Warp

Warp cannot fully set its active theme/font from files alone.

After install:

1. Open `Settings > Appearance > Current Theme`.
2. Choose the variant that matches your current macOS appearance:
   - `Apple Graphite Expanded Dark (mac-dev-setup)`
   - `Apple Graphite Expanded Light (mac-dev-setup)`
3. Open `Settings > Appearance > Text`.
4. Set font to `JetBrainsMono Nerd Font`.
5. Set font size to `14`.

### iTerm2

If you enabled iTerm2, the repo installs a dynamic profile named `mac-dev-setup`.

If you want that profile to become your normal default:

1. Open iTerm2 settings.
2. Select the profile.
3. Set it as your default profile.

### Ghostty And WezTerm

These are fully file-configured by the repo, but both intentionally preserve a local override file:

- `~/.config/ghostty/local.conf`
- `~/.config/wezterm/local.lua`

Put personal tweaks there instead of editing the managed base file.

## Theme Follow-Up

These are themed automatically by the repo:

- Ghostty
- WezTerm
- VS Code
- Neovim
- shell prompts and shell highlighting
- tmux
- `fzf`, `bat`, `delta`, `lazygit`, and `lazydocker`

These still need manual app-level theming:

- Warp: choose the matching Apple Graphite Expanded light or dark theme in-app
- iTerm2: if enabled, set the managed profile as default and switch profiles manually if you keep separate light/dark variants
- Zed: choose a matching light/dark appearance in Settings
- Sublime Text: choose the closest UI theme and color scheme manually
- IntelliJ / Android Studio / JetBrains IDEs: choose light/dark appearance in-app and keep `JetBrainsMono Nerd Font`
- Cursor and Windsurf: choose light/dark appearance in-app and keep `JetBrainsMono Nerd Font`
- Helix: set a matching theme manually if you use it regularly, since live macOS appearance switching is not automated there yet
- `bottom` and `k9s`: tune them manually if you want exact Apple Graphite Expanded colors; they otherwise mostly follow the terminal palette
