data "azurerm_subnet" "subnet_pep" {
  name                 = var.subnet_pep_name
  virtual_network_name = var.vnet_app_name
  resource_group_name  = var.resource_group
  depends_on           = [var.vnet_depends_on]
}

data "azurerm_private_dns_zone" "pdns_redis" {
  name                = var.pdns_redis_name
  resource_group_name = var.resource_group
  depends_on          = [var.vnet_depends_on]
}
