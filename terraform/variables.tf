variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "admin_username" {
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

variable "vms" {
  type = map(object({
    subnet = string
    vm_size   = string
  }))
}