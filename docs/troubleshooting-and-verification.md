# Troubleshooting and Verification

## Executive Summary

Use `./scripts/verify.sh` as the main audit command. Treat warnings differently from failures.

## Verification

Run:

```bash
./scripts/verify.sh
```

This checks:

- core commands present
- runtimes present
- Docker stack reachable
- selected editor CLIs present where applicable
- selected AI CLIs/apps present where applicable
- key managed config files exist

## Warning Policy

Warnings are acceptable for intentionally optional items.

Examples:

- IntelliJ CLI helper may warn on machines where Toolbox/IDEA shell scripts have not been generated yet
- desktop AI apps may warn on machines where the official download flow has not been completed yet

That should remain a warning, not a failure.

## Known First-Run Caveats

### VS Code

- extension install is more reliable with the VS Code UI closed

### IntelliJ / Toolbox

- first launch, sign-in, and install are GUI-driven
- shell scripts may need to be enabled from Toolbox/IDE settings before CLI helper passes cleanly

### Neovim

- first-run plugin sync may be noisy
- Treesitter may need `:TSUpdate`
- some toolchain/provider warnings are expected until Node/Python tooling is installed

### Docker / Colima

- Docker plugin discovery may require CLI plugin symlinks
- Colima must be running before Docker verification passes

### AI desktop tools

- some desktop AI tools are intentionally handled through vendor download/install flows
- bootstrap may open the official install/download page instead of silently forcing an install path
- rerun the targeted module after GUI installation if you want verification to pass cleanly

## Common Practical Checks

### Docker

```bash
colima status
docker info
docker buildx version
docker compose version
docker run --rm hello-world
```

### SSH

```bash
ssh -T git@github.com
```

### Neovim

```bash
nvim --headless "+quitall"
```

Inside Neovim:

```vim
:checkhealth
:Lazy
:TSUpdate
```

### AI tooling

```bash
zsh -i -c 'command -v codex || true'
zsh -i -c 'command -v cursor-agent || command -v cursor || true'
ls -d "/Applications/Codex.app" 2>/dev/null || true
ls -d "/Applications/Cursor.app" 2>/dev/null || true
ls -d "/Applications/Windsurf.app" 2>/dev/null || true
```

## Recommended Future Enhancements

- macOS defaults automation if you want a more opinionated machine baseline
- Colima lifecycle helper commands (`stop`, `reset`, etc.)
- richer VS Code extension bundles by language
- additional Neovim filetype cleanup for niche filetypes
- fuller chezmoi-native apply flow
- CI for repo linting/smoke tests
- broader AI tooling support once install paths stabilize
- richer AI-specific verification once workflows settle

## Version History

- v1: troubleshooting and verification guide created from the consolidated final documentation draft
