variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "vms" {
  type = map(object({
    subnet_id = string
    vm_size   = string
  }))
}
