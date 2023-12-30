# kube-apisix-linkerd-ory-kustomize

This is an example to deploy apisix as gateway with linkerd and the ory stack using kustomize

# Introduction

## What is GitOps?

GitOps is a way to do Continuous Delivery, it works by using Git as a source of truth for declarative infrastructure and workloads. For Kubernetes this means using `git push` instead of `kubectl apply/delete` or `helm install/upgrade`.

I've used GitHub to host the config repository and Flux as the GitOps delivery solution.

# Prerequisites

You will need the following tools installed:

- [Docker](https://docs.docker.com/install/)
- [k3d](https://k3d.io/v5.6.0/#releases)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [terraform](https://developer.hashicorp.com/terraform/install)
- [jq](https://stedolan.github.io/jq/download/)
- [pnpm](https://pnpm.js.org/en/installation) or any other package manager that can read the `package.json` file.

If you are using MacOS, you can install all the tools using [Homebrew](https://brew.sh/):

```bash
brew bundle
```

The complete list of tools can be found in the `Brewfile`.

# Getting Started

## Initializing Terraform

The first thing you need to do is to initialize Terraform:

```bash
pnpm run terraform:init
```

This will download the required Terraform plugins and modules on your local machine.

## Running external services

I've used [Docker Compose](https://docs.docker.com/compose/) to run the external services like databases since the goal of this project is not managing databases. But you can use any other providers like [AWS RDS](https://aws.amazon.com/rds/) or [Google Cloud SQL](https://cloud.google.com/sql).

> If you don't use the default docker compose or credentials, you will need to modify the terraform variables (cf. `terraform/configuring-vault/variables.tf`) to match with your configuration.

> I use the `host.k3d.internal` DNS to access the databases from the Kubernetes cluster. If you are using another Kubernetes cluster, you will need to modify the `host.k3d.internal` DNS to match with your configuration.

```bash
docker-compose up -d
```

This will start the following services:

- PostgreSQL (for Kratos)

## Provisioning a Kubernetes cluster

I've used [k3d](https://k3d.io/v5.6.0/#releases) to create a Kubernetes cluster with 1 master and 2 worker nodes.

You can also use other tools like [kind](https://kind.sigs.k8s.io/) or [minikube](https://minikube.sigs.k8s.io/docs/start/), but you will need to modify the terraform scripts (`terraform/provisioning-local-cluster`).

When the cluster is ready, the terraform will install [Flux](https://fluxcd.io/) automatically and it will start to sync the cluster with the config repository (`infrastructure/flux`).

This will deploy the following infrastructure components:

- [Linkerd](https://linkerd.io/) as the service mesh
- [APISIX](https://apisix.apache.org) as the gateway and ingress controller
- [Vault](https://www.vaultproject.io/) as the secrets manager
- [Cert Manager](https://cert-manager.io/) as the certificate manager with a Vault issuer
- [Weave GitOps](https://docs.gitops.weave.works/docs/intro-weave-gitops/) as the GitOps UI for Flux

and the following applications:

- [Kratos](https://www.ory.sh/kratos/docs/) as the identity provider
- [Oathkeeper](https://www.ory.sh/oathkeeper/docs/) as the identity and access controller
- [Kratos Self Service UI](https://github.com/ory/kratos-selfservice-ui-node) as the self service UI for Kratos

```bash
pnpm run kube:cluster:create
k3d kubeconfig merge kube-apisix-linkerd-ory
export KUBECONFIG=~/.config/k3d/kubeconfig-kube-apisix-linkerd-ory.yaml
```

## Configuring Vault

During the provisioning of the Kubernetes cluster, the deployment of Vault will fail and it will paused the rest of the apps deployment because it needs to be initialized and unsealed. But don't worry, Flux will retry the deployment until it succeeds.

You can use the following command to initialize and unseal Vault:

```bash
pnpm kube:vault:init
pnpm kube:vault:unseal
```

Once Vault is ready, you can use the following command to configure Vault:

```bash
kubectl port-forward -n vault service/vault 8200:8200 &
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=$(cat vault-keys.json | jq -r '.root_token')
pnpm kube:vault:config
```

> The `vault-keys.json` file is generated by the `kube:vault:init` command. When you run the command, you should be at the root of the project.

> Don't forget to kill the port-forward process when you are done.

This will configure Vault by enabling the Kubernetes auth method, create the secrets for the applications (especially for Kratos), and create the associated policies.

## Waiting for the cluster to be ready

Once Vault is ready and configured, Flux will start to deploy the rest of the components. You can use your best tool to check the status of the cluster, I've used [Weave GitOps](https://docs.gitops.weave.works/docs/intro-weave-gitops/) to check the status of the cluster.

```bash
kubectl port-forward -n flux-system service/weave-gitops 9001:9001
```

Open your browser and go to http://localhost:9001 to check the status of the cluster.

> Default username and password is `admin` and `flux` respectively.

## Accessing the applications

Once the cluster is ready, you can access the applications using the following links:

- [Kratos Self Service UI](http://auth.127.0.0.1.sslip.io)
- [Kratos Public API](http://identity.127.0.0.1.sslip.io/kratos/)

For the infrastructure components, you will have to create a port-forward to access them:

| Command                                                              | Username | Password            |
| -------------------------------------------------------------------- | -------- | ------------------- |
| `kubectl port-forward -n linkerd-viz service/web 8084:8084`          | `N/A`    | `N/A`               |
| `kubectl port-forward -n apisix service/apisix-dashboard 9000:80`    | `admin`  | `admin`             |
| `kubectl port-forward -n vault service/vault 8200:8200`              | `N/A`    | `<your-root-token>` |
| `kubectl port-forward -n flux-system service/weave-gitops 9001:9001` | `admin`  | `flux`              |

> The `N/A` means that you don't need to provide any username or password.

# Contributing

Contributions are welcome. Please follow the standard Git workflow - fork, branch, and pull request.

# License

This project is licensed under the Apache 2.0 - see the `LICENSE` file for details.
