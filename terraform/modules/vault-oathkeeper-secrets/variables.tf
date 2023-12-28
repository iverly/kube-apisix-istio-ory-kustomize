variable "kv_mount_path" {
  type        = string
  description = "The mount path for the KV secrets engine."
}

variable "kubernetes_auth_path" {
  type        = string
  description = "The mount path for the Kubernetes auth method."
}
