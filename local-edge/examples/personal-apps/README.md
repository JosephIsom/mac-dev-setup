# Personal App Example

This example starts two simple loopback-bound services:

- `journal` on `127.0.0.1:18080`
- `notes` on `127.0.0.1:18081`

The managed Caddy examples in `~/.config/mac-dev-setup/local-edge/caddy/sites.d/10-host-services.caddy` proxy:

- `https://journal.localhost`
- `https://notes.localhost`

Use:

```bash
./scripts/bootstrap-local-edge.sh setup
./scripts/bootstrap-local-edge.sh examples up
./scripts/bootstrap-local-edge.sh examples down
```
