data "azurerm_virtual_network" "vnet_app" {
  name                = var.vnet_app_name
  resource_group_name = var.resource_group
  depends_on          = [var.vnet_depends_on]
}

data "azurerm_subnet" "subnet_frontend" {
  name                 = var.subnet_apg_frontend_name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_app_name
  depends_on           = [var.vnet_depends_on]
}

data "azurerm_subnet" "subnet_backend" {
  name                 = var.subnet_apg_backend_name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_app_name
  depends_on           = [var.vnet_depends_on]
}
