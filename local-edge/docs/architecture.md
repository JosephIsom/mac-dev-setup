# Architecture Notes

## Why `local-edge/`

The main bootstrap script is for repeatable machine setup. The laptop edge stack is a layer above that: it coordinates a host reverse proxy, local TLS, port ownership, example workloads, and a kind ingress bridge. Keeping it in `local-edge/` makes that boundary explicit and keeps `scripts/bootstrap.sh` focused.

## Traffic Model

1. Caddy runs on macOS directly.
2. Caddy owns `80` and `443`.
3. Personal services listen on loopback ports such as `127.0.0.1:18080`.
4. kind ingress is mapped to `127.0.0.1:8080` and `127.0.0.1:8443`.
5. Caddy routes `*.localhost` hostnames either to loopback services or to the kind ingress entrypoint.

The repo ships an explicit `kind install-ingress-nginx` helper for a common example controller, but that controller is not auto-enabled by the main bootstrap or by `kind create`.

## Config Model

- Repo-owned templates live in `local-edge/templates/`.
- The operator-owned working copies live in `~/.config/mac-dev-setup/local-edge/`.
- `setup` is the only command that creates or relinks managed local-edge config.
- `setup` creates working copies only when absent.
- If a working copy already differs, setup leaves it alone and logs a warning instead of overwriting it.

## Homebrew Caddy Integration

Homebrew's service expects a live `Caddyfile` under the Homebrew prefix. The setup flow links that live path to the managed `~/.config/mac-dev-setup/local-edge/caddy/Caddyfile`.

If a Homebrew `Caddyfile` already exists, setup moves it into `~/.config/mac-dev-setup/local-edge/backups/caddy/` before linking the managed one. `safe-reset` uses that recorded backup to restore the prior file when possible.

## Why kind Uses `8080` And `8443`

The kind ingress entrypoint needs to stay reachable without colliding with Caddy. Exposing it on alternate host ports keeps the topology simple:

- Caddy remains the only process listening on `80` and `443`
- direct debugging of the ingress entrypoint is still possible on `127.0.0.1:8080` and `127.0.0.1:8443`
- work app hostnames can still be fronted consistently through Caddy
