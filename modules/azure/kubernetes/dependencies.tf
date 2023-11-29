data "azurerm_virtual_network" "vnet_app" {
  resource_group_name = var.resource_group
  name                = var.vnet_app_name
  depends_on          = [var.vnet_depends_on]
}

data "azurerm_subnet" "subnet_aks" {
  name                 = var.subnet_aks_name
  virtual_network_name = data.azurerm_virtual_network.vnet_app.name
  resource_group_name  = var.resource_group
  depends_on           = [var.vnet_depends_on]
}
