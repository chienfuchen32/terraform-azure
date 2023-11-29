data "azurerm_subnet" "snet_psql" {
  name                 = var.subnet_psql_name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_psql_name
  depends_on           = [var.vnet_depends_on]
}

data "azurerm_private_dns_zone" "pdns_psql" {
  name                = var.pdns_psql_name
  resource_group_name = var.resource_group
  depends_on          = [var.vnet_depends_on]
}
