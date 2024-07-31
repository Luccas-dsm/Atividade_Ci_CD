resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "student-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "student-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "student-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                = "student-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "student-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "student_vm" {
  name                       = "student-vm"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  size                       = "Standard_B1s"
  admin_username             = var.vm_admin_username
  allow_extension_operations = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUZV/39dc1n6PoIePC2D1PNyPM+hWO0dgaVxpmrgqxwx3oyELcNZlDl1kGMMj/n3t9O0BaKra3nJ0YAWm9jXE5sWndUuTush8WJBTMax7GVHn29kFODLrH8vlu0rsFDylWroSwY2a8OdeuruAW+KpQohzUjA/8BKYSQwmuPilic5W13dgt6WrgHDWxkGwBJlm5HQn+dbKnQjXBkwIkg0e5lD1idHWWL1AAFveTiw+gna3Ekna1V1TL7Ki7uYciQRWN1Vq4QMhFcnClFAHU9lkGsNJQTi/fJFDroRpWGZeTxbh+YGiL+veAFq4G5XLuFcH1si0AAutp4YpiRKnAU5j6Bqjoukg+/3La3182iwJLknSQ3VA2fjbzVxtEZ1lgraJTEIksf9mlNadTF+f6XLYTsv7eTcOx/CYW8UJZKMXINghR9YFFW0heLrYnH0DA5fjLS/fZRPJ3FSzwc3L42VR2vlfd7E7P9aC4t7k98ij6RfU4E4EhrdSit555ZyB88Pm6g80IjCehjn/SBBXq6YTlPgdpZ+dnFyDDUis5JBMPh+lY209O0jAQO4X4JvI88bpSqW+4pF6+hrIXTNVQz21DSNeo2wdzwg3ZL0qvLrQ5t1yywHJk4/lYC2AYnI1BCnzOUQINHbq7+rt9uCeJNYQ1KzT+q7Di0b9BayRAfVkZSQ== luccasdsm@hotmail.com"
  }
}
