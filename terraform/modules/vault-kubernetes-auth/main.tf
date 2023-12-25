resource "vault_auth_backend" "this" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend         = vault_auth_backend.this.path
  kubernetes_host = "https://kubernetes.default.svc:443"
}
