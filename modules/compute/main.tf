resource "azurerm_public_ip" "pip" {
  for_each            = var.vms
  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vms
  name                = each.key
  location            = var.location
  resource_group_name = var.rg_name
  size                = each.value.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


resource "azurerm_network_security_group" "vm_nsg" {
  for_each = var.vms
  name     = "${each.key}-nsg"
  location = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "ssh" {
  for_each = var.vms
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "22"
  source_address_prefix        = "*"    
  destination_address_prefix   = "*"
  resource_group_name          = var.rg_name
  network_security_group_name  = azurerm_network_security_group.vm_nsg[each.key].name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  for_each = var.vms
  network_interface_id          = azurerm_network_interface.nic[each.key].id
  network_security_group_id     = azurerm_network_security_group.vm_nsg[each.key].id
}