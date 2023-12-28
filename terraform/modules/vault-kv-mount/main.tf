resource "vault_mount" "this" {
  path        = var.path
  type        = "kv"
  options     = { version = "2" }
  description = var.description
}

resource "vault_kv_secret_backend_v2" "example" {
  mount                = vault_mount.this.path
  max_versions         = 5
  cas_required         = false
}
