######################################
#         Kratos Variables           #
######################################
variable "kratos_database_url" {
  type        = string
  description = "The database URL for Kratos."
  default     = "postgres://postgres:postgres@host.k3d.internal:5432/kratos?sslmode=disable&max_conns=20&max_idle_conns=4"
}

variable "kratos_secrets_default" {
  type        = string
  description = "The default secret for Kratos."
  default     = ""
}

variable "kratos_secrets_cookie" {
  type        = string
  description = "The cookie secret for Kratos."
  default     = ""
}

variable "kratos_secrets_cipher" {
  type        = string
  description = "The cipher secret for Kratos."
  default     = ""
}

variable "kratos_smtp_url" {
  type        = string
  description = "The SMTP URL for Kratos."
  default     = "smtps://test:test@host.k3d.internal:1025/?skip_ssl_verify=true"
}
