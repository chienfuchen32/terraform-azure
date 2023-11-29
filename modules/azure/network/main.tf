# vnet app
resource "azurerm_virtual_network" "vnet_app" {
  resource_group_name = var.resource_group
  name                = var.vnet_app_name
  location            = var.location
  address_space       = var.address_prefixes_vnet_app
}

# subnet of aks
resource "azurerm_subnet" "subnet_aks" {
  name                 = var.subnet_aks_name
  virtual_network_name = azurerm_virtual_network.vnet_app.name
  resource_group_name  = var.resource_group
  address_prefixes     = var.address_prefixes_subnet_aks
}

# subnet for private endpoint usage, like redis
resource "azurerm_subnet" "subnet_pep" {
  name                 = var.subnet_pep_name
  virtual_network_name = azurerm_virtual_network.vnet_app.name
  resource_group_name  = var.resource_group
  address_prefixes     = var.address_prefixes_subnet_pep
}

# subnet for azure load balancer internal usage
resource "azurerm_subnet" "subnet_lb" {
  name                 = var.subnet_lb_name
  virtual_network_name = azurerm_virtual_network.vnet_app.name
  resource_group_name  = var.resource_group
  address_prefixes     = var.address_prefixes_subnet_lb
}

# subnet of application gateway frontend
resource "azurerm_subnet" "subnet_apg_frontend" {
  name                 = var.subnet_apg_frontend_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_app.name
  address_prefixes     = var.address_prefixes_subnet_frontend
}

# subnet of application gateway backend
resource "azurerm_subnet" "subnet_apg_backend" {
  name                 = var.subnet_apg_backend_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_app.name
  address_prefixes     = var.address_prefixes_subnet_backend
}

# vnet postgresql
resource "azurerm_virtual_network" "vnet_psql" {
  name                = var.vnet_psql_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.address_prefixes_vnet_psql
}

# dedicated subnet of postgresql flexible server
resource "azurerm_subnet" "subnet_psql" {
  name                 = var.subnet_psql_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_psql.name
  address_prefixes     = var.address_prefixes_subnet_psql
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

# Private DNS Zone for PostgreSQL flexible server
resource "azurerm_private_dns_zone" "pdns_psql" {
  name                = var.pdns_psql_name
  resource_group_name = var.resource_group
}

# Private DNS Zone link to PostgreSQL flexible Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "pdns_psql_vnet_link_psql" {
  name                  = "vnet-link-psql"
  private_dns_zone_name = azurerm_private_dns_zone.pdns_psql.name
  virtual_network_id    = azurerm_virtual_network.vnet_psql.id
  resource_group_name   = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdns_psql_vnet_link_app" {
  name                  = "vnet-link-app"
  private_dns_zone_name = azurerm_private_dns_zone.pdns_psql.name
  virtual_network_id    = azurerm_virtual_network.vnet_app.id
  resource_group_name   = var.resource_group
}

# vnet cassandra
resource "azurerm_virtual_network" "vnet_cass" {
  name                = var.vnet_cass_name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.address_prefixes_vnet_cass
}

# subnet for Azure Managed Instance for Cassandra
resource "azurerm_subnet" "subnet_cass" {
  name                 = var.subnet_cass_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_cass.name
  address_prefixes     = var.address_prefixes_subnet_cass
}

# Private DNS Zone for Azure Cache for Redis
resource "azurerm_private_dns_zone" "pdns_redis" {
  name                = var.pdns_redis_name
  resource_group_name = var.resource_group
}

# Private DNS Zone link to Azure Cache for Redis Private DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "pdns_redis_vnet_link_app" {
  name                  = "vnet-link-app"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.pdns_redis.name
  virtual_network_id    = azurerm_virtual_network.vnet_app.id
}

# Vnet peering
resource "azurerm_virtual_network_peering" "vnet_peering_app_psql" {
  name                      = "app-to-psql"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet_app.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_psql.id
}

resource "azurerm_virtual_network_peering" "vnet_peering_psql_app" {
  name                      = "psql-to-app"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet_psql.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_app.id
}

resource "azurerm_virtual_network_peering" "vnet_peering_app_cass" {
  name                      = "app-to-cass"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet_app.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_cass.id
}

resource "azurerm_virtual_network_peering" "vnet_peering_cass_app" {
  name                      = "cass-to-app"
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vnet_cass.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_app.id
}
