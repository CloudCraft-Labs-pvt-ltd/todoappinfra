variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "sql_server_name" {
  type = string
}
variable "sql_database_name" {
  type = string
}