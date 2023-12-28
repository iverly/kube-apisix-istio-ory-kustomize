resource "random_password" "secrets_default" {
  length = 128

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "random_password" "secrets_cookie" {
  length = 128

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "random_password" "secrets_cipher" {
  length = 32

  upper   = true
  lower   = true
  numeric = true
  special = true

  override_special = "!@#%-_=+[]<>"
}

resource "vault_kv_secret_v2" "this" {
  mount               = var.kv_mount_path
  name                = "applications/ory/kratos"
  delete_all_versions = true

  data_json = jsonencode(
    {
      database_url    = var.database_url
      secrets_default = coalesce(var.secrets_default, random_password.secrets_default.result)
      secrets_cookie  = coalesce(var.secrets_cookie, random_password.secrets_cookie.result)
      secrets_cipher  = coalesce(var.secrets_cipher, random_password.secrets_cipher.result)
      smtp_url        = var.smtp_url
    }
  )
}

resource "vault_policy" "this" {
  name = "kratos_ro"

  policy = <<EOT
path "kv/data/applications/ory/kratos" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend   = var.kubernetes_auth_path
  role_name = "kratos"

  bound_service_account_names      = ["kratos", "kratos-migration-job", "kratos-courier"]
  bound_service_account_namespaces = ["ory"]

  token_ttl = 60
  token_policies = [
    vault_policy.this.name
  ]
}
