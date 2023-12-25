module "vault-kubernetes-auth" {
  source = "../modules/vault-kubernetes-auth"

  vault_address = var.vault_address
  vault_token   = var.vault_token
}

module "vault-pki-linkerd" {
  source = "../modules/vault-pki-linkerd"

  vault_address              = var.vault_address
  vault_token                = var.vault_token
  vault_kubernetes_auth_path = module.vault-kubernetes-auth.vault_kubernetes_auth_path
}
