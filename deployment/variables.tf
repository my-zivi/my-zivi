variable "app_postfix" {
  type = string
  validation {
    condition     = length(var.app_postfix) > 0
    error_message = "The postfix must be at least 1 character long."
  }
}

variable "postgres_admin_login" {
  type    = string
  default = "postgres"
}

variable "postgres_admin_password" {
  type = string
  validation {
    condition     = length(var.postgres_admin_password) > 0
    error_message = "The postgres admin password must be at least 1 character long."
  }
}
