module "vault-kubernetes-auth" {
  source = "../modules/vault-kubernetes-auth"
}

module "vault-pki-linkerd" {
  source = "../modules/vault-pki-linkerd"

  vault_kubernetes_auth_path = module.vault-kubernetes-auth.vault_kubernetes_auth_path
}
