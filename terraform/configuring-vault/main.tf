module "vault-kubernetes-auth" {
  source = "../modules/vault-kubernetes-auth"
}

module "vault-kv-mount" {
  source = "../modules/vault-kv-mount"

  path = "kv"
}
