variable "kv_mount_path" {
  type        = string
  description = "The mount path for the KV secrets engine."
}

variable "kubernetes_auth_path" {
  type        = string
  description = "The mount path for the Kubernetes auth method."
}

variable "database_url" {
  type        = string
  description = "The database URL for Kratos."
}

variable "secrets_default" {
  type        = string
  description = "The default secret for Kratos."
}

variable "secrets_cookie" {
  type        = string
  description = "The cookie secret for Kratos."
}

variable "secrets_cipher" {
  type        = string
  description = "The cipher secret for Kratos."
}

variable "smtp_url" {
  type        = string
  description = "The SMTP URL for Kratos."
}
