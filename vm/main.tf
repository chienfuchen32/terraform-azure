resource "azurerm_virtual_network" "vnet-vm" {
  name                = var.vnet_name
  address_space       = ["172.16.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_network_security_group" "nsg-vm" {
  name                = "nsg-vm"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = [""]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "snet-vm-em" {
  name                 = "snet-vm-em"
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_public_ip" "pip-vm" {
  name                = "pip-vm"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic-vm" {
  name                = "nic-vm"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.snet-vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-association-vm" {
  network_interface_id      = azurerm_network_interface.nic-vm.id
  network_security_group_id = azurerm_network_security_group.nsg-vm.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.nic-vm.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "disk-vm"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "vm"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("id_rsa.pem.pub")
  }
}
