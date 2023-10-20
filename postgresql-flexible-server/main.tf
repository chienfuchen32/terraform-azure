provider "azurerm" {
  features {}
  skip_provider_registration = true
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["172.22.0.0/16"]
}

resource "azurerm_subnet" "snet-psql" {
  name                 = "snet-psql"
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = ["172.22.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
resource "azurerm_private_dns_zone" "dns_psql" {
  name                = "dns-psql.private.postgres.database.azure.com"
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.pdns_psql_evm.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group
}

resource "azurerm_postgresql_flexible_server" "psql" {
  name                   = "psql"
  resource_group_name    = var.resource_group
  location               = var.location
  version                = "14"
  delegated_subnet_id    = azurerm_subnet.snet-psql.id
  private_dns_zone_id    = azurerm_private_dns_zone.dns_psql.id
  administrator_login    = "admin"
  administrator_password = ""
  zone                   = "1"

  storage_mb = 131072

  sku_name   = "GP_Standard_D2ds_v4"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnet_link]

}
