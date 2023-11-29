data "azurerm_virtual_network" "vnet_cassandra" {
  name                = var.vnet_cassandra_name
  resource_group_name = var.resource_group
  depends_on          = [var.vnet_depends_on]
}

data "azurerm_subnet" "subnet_cassandra" {
  name                 = "subnet-cass"
  resource_group_name  = var.resource_group
  virtual_network_name = data.azurerm_virtual_network.vnet_cassandra.name
  depends_on           = [var.vnet_depends_on]
}
