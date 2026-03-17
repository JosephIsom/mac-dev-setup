# Troubleshooting

## Caddy Fails To Start

- Confirm setup has been completed with `./scripts/bootstrap-local-edge.sh setup`.
- Run `./scripts/bootstrap-local-edge.sh caddy validate`.
- Confirm Homebrew's live `Caddyfile` points at `~/.config/mac-dev-setup/local-edge/caddy/Caddyfile`.
- Retry with `./scripts/bootstrap-local-edge.sh caddy start --sudo-service` if your machine rejects privileged ports for a user launchd service.

## Browsers Warn About The Certificate

- Run `./scripts/bootstrap-local-edge.sh caddy trust-certs`.
- If the trust command says the root certificate does not exist yet, start Caddy and visit `https://local-edge.localhost` once, then retry.
- Until the CA is trusted, use `./scripts/bootstrap-local-edge.sh smoke-test --insecure`.

## kind Work Hostnames Return 404 Or Connection Errors

- Confirm the cluster exists with `kind get clusters`.
- Install or reinstall the ingress controller you expect to use.
- For the included example flow, use `./scripts/bootstrap-local-edge.sh kind install-ingress-nginx`.
- Check that your workload `Ingress` uses the same hostname that Caddy forwards.
- Confirm the managed work routes file still points at `127.0.0.1:8080`.

## Docker Examples Fail To Start

- Make sure Docker is reachable with `docker info`.
- If you use Colima, start it with `colima start`.
- Re-run `./scripts/bootstrap-local-edge.sh examples up`.

## Reset Safely

Use:

```bash
./scripts/bootstrap-local-edge.sh safe-reset
```

That command:

- stops Caddy
- tears down the example workloads
- deletes the managed kind cluster
- restores the prior Homebrew `Caddyfile` when it was backed up
- archives the managed `~/.config/mac-dev-setup/local-edge` state instead of deleting it outright
