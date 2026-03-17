# Editors And AI

This page covers editor modules, VS Code integration, IntelliJ guidance, and AI tools.

## VS Code

| Module | Default | What it does | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `editors/vscode/vscode-app.sh` | On | Installs the VS Code desktop app. | Launch VS Code normally. | [Visual Studio Code](https://code.visualstudio.com/) | Sign in to Settings Sync if you use it. |
| `editors/vscode/vscode-cli.sh` | On | Enables `code` on the shell PATH. | Use `code .`, `code -n`, `code --install-extension`. | [Command Line Interface](https://code.visualstudio.com/docs/editor/command-line) | None. |
| `editors/vscode/extensions.sh` | On | Aggregates all staged module-owned extension manifests and installs them. | Re-run it after enabling a module with VS Code assets. | [Extensions](https://code.visualstudio.com/docs/editor/extension-marketplace) | Keep `scripts/bootstrap.sh` and `scripts/verify.sh` aligned. |
| `editors/vscode/settings.sh` | On | Merges staged module-owned settings fragments into `settings.json`. | Re-run it after enabling or disabling modules with VS Code settings. | [User Settings](https://code.visualstudio.com/docs/getstarted/settings) | The repo now rebuilds staged VS Code state per bootstrap run. |

### VS Code Core Extensions

The repo installs a core baseline including:

- EditorConfig
- GitLens
- Prettier
- Code Spell Checker
- Error Lens
- Todo Highlight
- Todo Tree
- Indent Rainbow
- Project Manager
- Hex Editor
- Material Icon Theme
- Path Intellisense
- Sort Lines
- Color Highlight
- Git History
- GitHub Pull Requests
- Vim
- OpenAI / ChatGPT

Additional extensions come from enabled language, container, cloud, and AI modules.

## Other Editors

| Module | Default | What it does | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `editors/cursor/cursor-app.sh` | On | Installs the Cursor desktop editor. | Launch Cursor normally. | [Cursor](https://www.cursor.com/) | Sign in if you use Cursor’s hosted features. |
| `editors/cursor/cursor-cli.sh` | On | Installs the Cursor CLI through Homebrew. | Use `cursor` or `cursor-agent` from the terminal. | [Cursor CLI cask](https://formulae.brew.sh/cask/cursor-cli) | None. |
| `editors/intellij/toolbox.sh` | On | Installs JetBrains Toolbox. | Launch Toolbox to install IntelliJ IDEA and other JetBrains IDEs. | [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/) | Sign in and install IntelliJ IDEA from Toolbox. |
| `editors/intellij/idea.sh` | On | Writes IntelliJ IDEA setup notes and detects an existing install. | Use it as the IntelliJ baseline helper. | [IntelliJ IDEA](https://www.jetbrains.com/idea/) | Open Toolbox, install IntelliJ IDEA, and optionally enable Toolbox shell scripts. |
| `editors/intellij/intellij-cli.sh` | On | Detects Toolbox-generated CLI launchers such as `idea`. | Use `idea .` once Toolbox has generated the shell scripts. | [JetBrains command-line launcher](https://www.jetbrains.com/help/idea/opening-files-from-command-line.html) | In Toolbox, enable shell scripts if `idea` is missing. |
| `editors/intellij/ai.sh` | On | Writes IntelliJ AI setup notes. | Use it as the follow-up guide for AI Assistant, Junie, and Gemini Code Assist. | [JetBrains AI Assistant](https://www.jetbrains.com/help/ai-assistant/installation-guide-ai-assistant.html), [Junie](https://www.jetbrains.com/junie/), [Gemini Code Assist](https://codeassist.google/) | Install plugins from inside IntelliJ after Toolbox/IDEA are ready. |
| `editors/windsurf/windsurf-app.sh` | On | Installs Windsurf. | Launch Windsurf normally. | [Windsurf](https://windsurf.com/) | Sign in if needed. |
| `editors/android-studio/android-studio-app.sh` | Optional | Installs Android Studio and writes setup notes. | Use it for Android SDK, emulator, and Android IDE workflows. | [Android Studio](https://developer.android.com/studio) | Complete the Setup Wizard and install SDK/emulator components. |
| `editors/helix/helix-cli.sh` | Optional | Installs Helix editor. | Run `hx`. | [Helix](https://helix-editor.com/) | Optional. |
| `editors/neovim/neovim-cli.sh` | Optional | Installs Neovim, managed baseline config, `lazy.nvim`, and syncs plugins. | Run `nvim`; put personal edits in `~/.config/nvim/lua/mac_dev_setup/local.lua`. | [Neovim](https://neovim.io/), [lazy.nvim](https://github.com/folke/lazy.nvim) | The repo owns the baseline; keep personal changes in `local.lua`. |
| `editors/sublime-text/sublime-text-app.sh` | Optional | Installs Sublime Text and enables `subl`. | Use `subl .` or launch the app. | [Sublime Text](https://www.sublimetext.com/) | None. |
| `editors/zed/zed-app.sh` | Optional | Installs Zed and writes CLI setup notes. | Launch Zed normally. | [Zed](https://zed.dev/) | Open Zed and run `cli: install` from the command palette to install the `zed` CLI. |
| `editors/kiro/kiro-app.sh` | Optional | Installs Kiro IDE. | Launch the app normally. | [Kiro](https://kiro.dev/) | Optional. |
| `editors/kiro/kiro-cli.sh` | Optional | Installs Kiro CLI and command router. | Use `kiro-cli` and `kiro`. | [Kiro install](https://kiro.dev/docs/getting-started/installation/) | The script sets the CLI as default and installs the command router. |

## AI Modules

| Module | Default | What it does | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `ai/codex/codex-app.sh` | On | Installs the Codex desktop app. | Launch the app normally. | [Codex App cask](https://formulae.brew.sh/cask/codex-app) | Sign in if required by the app. |
| `ai/codex/codex-cli.sh` | On | Installs Codex CLI and shell completion. | Use `codex` from the terminal. | [Codex CLI cask](https://formulae.brew.sh/cask/codex), [OpenAI](https://openai.com/) | Sign in or configure the CLI according to your preferred OpenAI auth flow. |
| `ai/aider/aider-cli.sh` | Optional | Installs `aider`. | Use `aider` in Git repos when you want a terminal-first coding agent. | [Aider](https://aider.chat/) | Configure model/provider access if needed. |
| `ai/claude/claude-cli.sh` | Optional | Installs Claude Code CLI plus VS Code assets and writes IDE notes. | Run `claude` in a terminal or inside an editor terminal. | [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) | In VS Code, Cursor, Windsurf, or JetBrains terminals, run `claude` once to let it install editor integration. Use `/ide` from an external terminal if needed. |
| `ai/chatgpt/chatgpt-app.sh` | Optional | Installs the ChatGPT desktop app. | Launch the app normally. | [ChatGPT cask](https://formulae.brew.sh/cask/chatgpt) | Sign in. |
| `ai/continue/continue-cli.sh` | Optional | Installs Continue CLI plus VS Code assets. | Use `cn` from the terminal and the VS Code extension if enabled. | [Continue](https://docs.continue.dev/) | Configure your model providers inside Continue. |
| `ai/gemini/gemini-cli.sh` | Optional | Installs Gemini CLI plus VS Code assets. | Use `gemini` from the terminal. | [Gemini CLI](https://developers.google.com/gemini-code-assist/docs/gemini-cli) | Sign in or configure your account/project as needed. |
| `ai/github-copilot/github-copilot-cli.sh` | Optional | Installs GitHub Copilot CLI and stages VS Code Copilot assets. | Use `copilot` from the terminal and finish Copilot setup inside VS Code. | [GitHub Copilot CLI](https://cli.github.com/manual/gh_extension_install), [GitHub Copilot](https://github.com/features/copilot) | Manual step after bootstrap: sign in to GitHub in VS Code, enable Copilot on your account, and let VS Code finish installing/activating any required Copilot extensions. |
| `ai/ollama/ollama-cli.sh` | Optional | Installs Ollama CLI for local models. | Use `ollama serve`, `ollama pull`, `ollama run`. | [Ollama](https://ollama.com/) | Pull the models you want after install. |
| `ai/lm-studio/lm-studio-app.sh` | Optional | Installs LM Studio. | Launch it for local model download and serving. | [LM Studio](https://lmstudio.ai/) | Download models inside the app after first launch. |

## VS Code Extension Ownership

The repo uses a module-owned VS Code model:

- each tool or language can stage its own `*-vscode-extensions.txt`
- each tool or language can stage its own `*-vscode-settings.jsonc`
- some modules also stage task, launch, or workspace templates

That means enabling a runtime or tool can automatically add:

- the right VS Code extension
- matching editor settings
- reusable template files under `~/.config/mac-dev-setup/vscode/templates`

## Neovim

Neovim is optional, but once enabled it gets:

- a managed baseline config
- `lazy.nvim`
- shared UI/editor plugins
- module-owned language/tool specs

Use `~/.config/nvim/lua/mac_dev_setup/local.lua` for local overrides.
