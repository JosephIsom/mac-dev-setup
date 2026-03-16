# Cloud, Containers, And Infra

This page covers cloud CLIs, container tooling, Kubernetes tooling, and infrastructure support.

## Cloud Wrapper Modules

These bundle related provider tools so you can enable a whole provider stack at once.

| Module | Default | What it does | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `cloud/aws/aws.sh` | On | Runs the AWS-related modules below. | Enable or disable the AWS child modules through bootstrap as needed. | [AWS](https://aws.amazon.com/) | You will still need to authenticate. |
| `cloud/gcp/gcp.sh` | On | Runs the Google Cloud modules below. | Use it as the GCP bundle toggle. | [Google Cloud](https://cloud.google.com/) | Authenticate with `gcloud auth login` after install. |
| `cloud/azure/azure.sh` | On | Runs the Azure modules below. | Use it as the Azure bundle toggle. | [Microsoft Azure](https://azure.microsoft.com/) | Authenticate with `az login` after install. |
| `cloud/digitalocean/digitalocean.sh` | On | Runs the DigitalOcean modules below. | Use it as the DigitalOcean bundle toggle. | [DigitalOcean](https://www.digitalocean.com/) | Authenticate with `doctl auth init`. |
| `cloud/cloudflare/cloudflare.sh` | On | Runs Cloudflare tooling. | Use it when you work with Workers or Cloudflare services. | [Cloudflare](https://www.cloudflare.com/) | Authenticate with `wrangler login` if you use Wrangler. |
| `cloud/flyio/flyio.sh` | On | Runs Fly.io tooling. | Use it for Fly app deploys and operations. | [Fly.io](https://fly.io/) | Authenticate with `fly auth login`. |

## Cloud Tool Modules

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `cloud/aws/awscli.sh` | On | AWS CLI plus completion and VS Code AWS Toolkit manifest. | Use `aws configure sso`, `aws sts get-caller-identity`, `aws s3 ls`. | [AWS CLI](https://docs.aws.amazon.com/cli/) | Sign in with your preferred AWS auth flow. |
| `cloud/aws/aws-config.sh` | On | Managed AWS config support. | Use `~/.aws/config` as your main CLI profile file. | [AWS CLI config](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) | Add your real profiles after bootstrap. |
| `cloud/aws/aws-sso-cli.sh` | On | Helper for AWS SSO profile workflows. | Use `aws-sso` commands if your org uses this tool. | [aws-sso-cli](https://github.com/synfinatic/aws-sso-cli) | Configure it with your org/account details. |
| `cloud/aws/aws-vault.sh` | On | Secure AWS credential/session management. | Use `aws-vault exec <profile> -- <command>`. | [aws-vault](https://github.com/99designs/aws-vault) | Set up profiles and keychain entries. |
| `cloud/aws/awscli-local.sh` | On | `awslocal` for LocalStack. | Use `awslocal` in LocalStack-backed projects. | [awscli-local](https://github.com/localstack/awscli-local) | Only useful if you also use LocalStack. |
| `cloud/aws/localstack.sh` | On | Local AWS emulation CLI. | Use `localstack` for local cloud emulation. | [LocalStack](https://www.localstack.cloud/) | Start/configure it per project. |
| `cloud/aws/okta-aws-cli.sh` | On | Okta-backed AWS role access helper. | Use it if your company relies on Okta for AWS federation. | [okta-aws-cli](https://github.com/okta/okta-aws-cli) | Configure it with your org and Okta app details. |
| `cloud/azure/azure-cli.sh` | On | Azure CLI. | Use `az login`, `az account show`, `az group list`. | [Azure CLI](https://learn.microsoft.com/cli/azure/) | Sign in after install. |
| `cloud/gcp/gcloud-cli.sh` | On | Google Cloud CLI plus shell integration. | Use `gcloud auth login`, `gcloud config set project`, `gcloud run deploy`. | [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) | Sign in and choose a project. |
| `cloud/digitalocean/doctl.sh` | On | DigitalOcean CLI plus completion. | Use `doctl auth init`, `doctl compute droplet list`. | [doctl](https://docs.digitalocean.com/reference/doctl/) | Authenticate after install. |
| `cloud/cloudflare/wrangler.sh` | On | Wrangler CLI plus shell integration. | Use `wrangler login`, `wrangler dev`, `wrangler deploy`. | [Wrangler](https://developers.cloudflare.com/workers/wrangler/) | Authenticate if you deploy Workers. |
| `cloud/flyio/flyctl.sh` | On | Fly CLI plus completion. | Use `fly launch`, `fly deploy`, `fly status`. | [flyctl](https://fly.io/docs/flyctl/) | Authenticate after install. |

## Container, Docker, And Kubernetes Modules

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `containers/colima/colima.sh` | On | Local container runtime on macOS. | Use `colima start`, `colima status`, `colima stop`. | [Colima](https://github.com/abiosoft/colima) | Colima resource defaults come from `config/user.env`. |
| `containers/docker/docker-cli.sh` | On | Docker CLI plus completion and VS Code tasks/settings. | Use `docker build`, `docker run`, `docker ps`. | [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/) | Requires a working container runtime such as Colima. |
| `containers/buildx/buildx.sh` | On | Docker Buildx plugin. | Use `docker buildx build` for multi-platform or advanced builds. | [Buildx](https://docs.docker.com/buildx/working-with-buildx/) | None. |
| `containers/compose/compose.sh` | On | Docker Compose CLI plugin. | Use `docker compose up`, `docker compose down`. | [Docker Compose](https://docs.docker.com/compose/) | None. |
| `containers/kind/kind.sh` | On | Local Kubernetes clusters in Docker. | Use `kind create cluster`, `kind delete cluster`. | [kind](https://kind.sigs.k8s.io/) | None. |
| `containers/kubectl/kubectl.sh` | On | Kubernetes CLI plus completion and VS Code settings. | Use `kubectl get pods`, `kubectl apply -f`, `kubectl config get-contexts`. | [kubectl](https://kubernetes.io/docs/reference/kubectl/) | None. |
| `containers/helm/helm.sh` | On | Helm CLI plus completion. | Use `helm repo add`, `helm install`, `helm upgrade`. | [Helm](https://helm.sh/) | None. |
| `containers/k9s/k9s.sh` | On | TUI for Kubernetes clusters. | Run `k9s`. | [k9s](https://k9scli.io/) | None. |
| `containers/tilt/tilt.sh` | On | Tilt for local Kubernetes dev loops, plus VS Code assets. | Use `tilt up` in Tilt-based projects. | [Tilt](https://tilt.dev/) | None. |
| `containers/kubectx/kubectx.sh` | On | Fast context/namespace switching. | Use `kubectx` and `kubens`. | [kubectx](https://github.com/ahmetb/kubectx) | None. |
| `containers/stern/stern.sh` | On | Tail logs from multiple pods. | Use `stern <pod-selector>`. | [stern](https://github.com/stern/stern) | None. |
| `containers/ctlptl/ctlptl.sh` | On | Control-plane lifecycle helper. | Use it in repos that standardize on `ctlptl` for local clusters. | [ctlptl](https://github.com/tilt-dev/ctlptl) | None. |
| `containers/testcontainers-desktop/testcontainers-desktop.sh` | On | Desktop companion for Testcontainers workflows. | Launch the app if you use Testcontainers-based projects. | [Testcontainers Desktop](https://testcontainers.com/desktop/) | Launch the app, sign in with Docker, and choose the runtime you want to use. |
| `containers/colima/colima-start.sh` | On | Convenience startup helper. | Use it to start Colima with the configured resources. | [Colima](https://github.com/abiosoft/colima) | None. |
| `containers/docker/docker-verify.sh` | On | Container-stack health check. | Use it if you want to verify Docker can talk to the runtime. | [Docker CLI](https://docs.docker.com/) | None. |

## Infrastructure And Spec Tooling

Infrastructure and spec-focused modules are documented in [Runtimes And Tooling](runtimes-and-tooling.md), especially:

- Terraform / HCL
- Dockerfile
- Compose
- Helm chart authoring
- OpenAPI
- AsyncAPI
- JSON Schema
- Ansible
- Rego / OPA
- CUE
- Jsonnet
- Bicep

Use that page when you want formatter, linter, LSP, and editor-integration details.
