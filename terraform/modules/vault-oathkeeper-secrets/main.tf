resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_uuid" "this" {}

data "jwks_from_key" "this" {
  key = tls_private_key.this.private_key_pem

  kid = random_uuid.this.result
  use = "sig"
  alg = "RS256"
}

resource "vault_kv_secret_v2" "this" {
  mount               = var.kv_mount_path
  name                = "applications/ory/oathkeeper/jwks"
  delete_all_versions = true

  data_json = data.jwks_from_key.this.jwks
}

resource "vault_policy" "this" {
  name = "oathkeeper_ro"

  policy = <<EOT
path "kv/data/applications/ory/oathkeeper/jwks" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend   = var.kubernetes_auth_path
  role_name = "oathkeeper"

  bound_service_account_names      = ["oathkeeper"]
  bound_service_account_namespaces = ["ory"]

  token_ttl = 60
  token_policies = [
    vault_policy.this.name
  ]
}
