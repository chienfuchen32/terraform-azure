provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_virtual_network" "vnet_cassandra" {
  name                = "vnet-cassandra"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["172.28.0.0/16"]
}

resource "azurerm_subnet" "subnet_cassandra" {
  name                 = "subnet-cassandra"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_cassandra.name
  address_prefixes     = ["172.28.1.0/24"]
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_virtual_network.vnet_cassandra.id
  role_definition_name = "Network Contributor"
  principal_id         = "dd4ec2c3-4395-4945-a7a4-253df4c51a8f"
}

resource "azurerm_cosmosdb_cassandra_cluster" "cluster_cassandra" {
  name                           = "cassandra-cluster"
  resource_group_name            = var.resource_group
  location                       = var.location
  delegated_management_subnet_id = azurerm_subnet.subnet_cassandra.id
  default_admin_password         = ""

  depends_on = [azurerm_role_assignment.role_assignment]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "datacenter" {
  name                           = "datacenter"
  location                       = var.location
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.cluster_cassandra.id
  delegated_management_subnet_id = azurerm_subnet.subnet_cassandra.id
  node_count                     = 3
  disk_count                     = 4
  sku_name                       = "Standard_D8s_v5"
  availability_zones_enabled     = false
}

