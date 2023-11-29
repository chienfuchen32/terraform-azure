resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_virtual_network.vnet_cassandra.id
  role_definition_name = "Network Contributor"
  principal_id         = "dd4ec2c3-4395-4945-a7a4-253df4c51a8f"
}

resource "azurerm_cosmosdb_cassandra_cluster" "cluster_cassandra" {
  name                           = var.cassandra_name
  resource_group_name            = var.resource_group
  location                       = var.location
  version                        = var.cassandra_version
  delegated_management_subnet_id = data.azurerm_subnet.subnet_cassandra.id
  default_admin_password         = var.password

  depends_on = [azurerm_role_assignment.role_assignment]
}

resource "azurerm_cosmosdb_cassandra_datacenter" "datacenter_sea" {
  cassandra_cluster_id           = azurerm_cosmosdb_cassandra_cluster.cluster_cassandra.id
  delegated_management_subnet_id = data.azurerm_subnet.subnet_cassandra.id
  availability_zones_enabled     = false

  for_each   = var.data_center
  name       = each.value.name
  location   = each.value.location
  sku_name   = each.value.sku_name
  node_count = each.value.node_count
  disk_count = each.value.disk_count
}

