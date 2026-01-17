location          = "Southeast Asia"
rg_name           = "app-rg1"
admin_username    = "azureuser"
admin_password    = "P@ssword123!"
sql_server_name   = "sql-server-app"
sql_database_name = "sql-db-app"

vms = {
  frontendvm = {
    subnet = "frontend"
    vm_size = "Standard_B1s"
  }
  backendvm = {
    subnet = "backend"
    vm_size = "Standard_B1s"
  }

  CentralMonitoringVM = {
    subnet = "centralvmSubnet"
    vm_size = "Standard_B1s"
  }

}