module "rg" {
  source   = "../modules/resource_group"
  name     = var.rg_name
  location = var.location
}

module "network" {
  source     = "../modules/network"
  rg_name    = module.rg.rg_name
  location   = module.rg.location
  depends_on = [module.rg]

}

module "compute" {
  source         = "../modules/compute"
  rg_name        = module.rg.rg_name
  location       = module.rg.location
  admin_username = var.admin_username
  admin_password = var.admin_password
  depends_on     = [module.network]


  vms = {
    for vm_name, vm in var.vms :
    vm_name => {
      vm_size   = vm.vm_size
      subnet_id = vm.subnet == "frontend" ? module.network.frontend_subnet_id : module.network.backend_subnet_id
    }
  }

}
module "database" {
  source            = "../modules/database"
  rg_name           = module.rg.rg_name
  location          = module.rg.location
  admin_password    = var.admin_password
  depends_on        = [module.compute]
  sql_server_name   = var.sql_server_name
  sql_database_name = var.sql_database_name
}
