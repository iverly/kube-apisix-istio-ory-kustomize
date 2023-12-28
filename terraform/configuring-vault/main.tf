module "vault-kubernetes-auth" {
  source = "../modules/vault-kubernetes-auth"
}

module "vault-kv-mount" {
  source = "../modules/vault-kv-mount"

  path = "kv"
}

module "vault-kratos-secrets" {
  source = "../modules/vault-kratos-secrets"

  kv_mount_path        = module.vault-kv-mount.path
  kubernetes_auth_path = module.vault-kubernetes-auth.path

  database_url    = var.kratos_database_url
  secrets_default = var.kratos_secrets_default
  secrets_cookie  = var.kratos_secrets_cookie
  secrets_cipher  = var.kratos_secrets_cipher
  smtp_url        = var.kratos_smtp_url
}
