# kind Workload Example

This example deploys a simple HTTP echo workload behind a Kubernetes `Ingress` for:

- `work-demo.localhost`

It assumes:

- `./scripts/bootstrap-local-edge.sh setup` has already been run
- the `local-edge` kind cluster exists
- an ingress controller has been installed in the cluster
- if you want the included example path, run `./scripts/bootstrap-local-edge.sh kind install-ingress-nginx`
- Caddy is running and fronting the kind hostname from the managed `20-kind-services.caddy` file

The example is applied automatically by:

```bash
./scripts/bootstrap-local-edge.sh examples up
```

You can also apply it directly:

```bash
kubectl --context kind-local-edge apply -f local-edge/examples/kind-workload/demo-app.yaml
```
