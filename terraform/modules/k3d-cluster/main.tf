resource "k3d_cluster" "this" {
  name    = "kube-apisix-linkerd-ory"
  servers = 1
  agents  = 2

  k3s {
    extra_args {
      arg          = "--disable=traefik"
      node_filters = ["servers:*"]
    }
  }

  port {
    host_port      = 80
    container_port = 80
    node_filters = [
      "loadbalancer",
    ]
  }
}
