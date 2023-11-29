resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = var.psql_name
  resource_group_name    = var.resource_group
  location               = var.location
  version                = var.psql_version
  delegated_subnet_id    = data.azurerm_subnet.snet_psql.id
  private_dns_zone_id    = data.azurerm_private_dns_zone.pdns_psql.id
  administrator_login    = var.admin
  administrator_password = var.password
  zone                   = var.zone

  storage_mb = var.storage_mb

  sku_name   = var.sku_name
  depends_on = [var.vnet_depends_on]
}
