resource "vault_mount" "this" {
  path        = "pki_linkerd"
  type        = "pki"
  description = "The PKI mount for Linkerd certificates"

  default_lease_ttl_seconds = 86400
  max_lease_ttl_seconds     = 315360000
}

resource "vault_pki_secret_backend_root_cert" "this" {
  backend     = vault_mount.this.path
  type        = "internal"
  common_name = "root.linkerd.cluster.local"
  ttl         = 315360000
  key_type    = "ec"
  key_bits    = 256
}

resource "vault_pki_secret_backend_config_urls" "this" {
  backend                 = vault_mount.this.path
  issuing_certificates    = ["http://vault.vault.svc.cluster.local:8200/v1/pki_linkerd/ca"]
  crl_distribution_points = ["http://vault.vault.svc.cluster.local:8200/v1/pki_linkerd/crl"]
}

resource "vault_policy" "this" {
  name = "pki_policy"

  policy = <<EOT
path "pki_linkerd*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend   = var.vault_kubernetes_auth_path
  role_name = "vault-linkerd-issuer"

  bound_service_account_names      = ["cert-manager"]
  bound_service_account_namespaces = ["cert-manager"]
  audience                         = "vault://vault-linkerd-issuer"

  token_ttl = 60
}
