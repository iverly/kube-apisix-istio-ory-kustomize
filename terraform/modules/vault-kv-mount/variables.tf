variable "path" {
  description = "The path of the mount"
  type        = string
}

variable "description" {
  description = "The description of the mount"
  type        = string
  default     = "KV Version 2 secret engine mount"
}
