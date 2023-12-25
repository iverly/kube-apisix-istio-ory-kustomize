variable "vault_address" {
  description = "Address of the Vault server"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Vault token"
  type        = string
}

variable "vault_kubernetes_auth_path" {
  description = "Path to the Kubernetes auth backend"
  type        = string
  default     = "auth/kubernetes"
}
