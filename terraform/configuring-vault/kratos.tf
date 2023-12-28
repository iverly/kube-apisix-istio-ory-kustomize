resource "random_password" "kratos_secrets_default" {
  length = 128

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "random_password" "kratos_secrets_cookie" {
  length = 128

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "random_password" "kratos_secrets_cipher" {
  length = 32

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "vault_kv_secret_v2" "kratos" {
  mount               = module.vault-kv-mount.path
  name                = "applications/ory/kratos"
  delete_all_versions = true

  data_json = jsonencode(
    {
      database_url    = var.kratos_database_url
      secrets_default = coalesce(var.kratos_secrets_default, random_password.kratos_secrets_default.result)
      secrets_cookie  = coalesce(var.kratos_secrets_cookie, random_password.kratos_secrets_cookie.result)
      secrets_cipher  = coalesce(var.kratos_secrets_cipher, random_password.kratos_secrets_cipher.result)
      smtp_url        = var.kratos_smtp_url
    }
  )

  depends_on = [module.vault-kv-mount]
}

resource "vault_policy" "kratos" {
  name = "kratos_ro"

  policy = <<EOT
path "kv/data/applications/ory/kratos" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "kratos" {
  backend   = module.vault-kubernetes-auth.vault_kubernetes_auth_path
  role_name = "kratos"

  bound_service_account_names      = ["kratos", "kratos-migration-job", "kratos-courier"]
  bound_service_account_namespaces = ["ory"]

  token_ttl = 60
  token_policies = [
    vault_policy.kratos.name
  ]
}
