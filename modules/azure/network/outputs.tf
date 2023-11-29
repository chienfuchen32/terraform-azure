output "vnet_app_name" {
  description = "Name of app"
  value       = azurerm_virtual_network.vnet_app.name
  depends_on  = [azurerm_virtual_network.vnet_app]
}
output "subnet_apg_frontend_name" {
  description = "Name of application gateway subnet frontend"
  value       = azurerm_subnet.subnet_apg_frontend.name
  depends_on  = [azurerm_subnet.subnet_apg_frontend]
}
output "subnet_apg_backend_name" {
  description = "Name of application gateway subnet backend"
  value       = azurerm_subnet.subnet_apg_backend.name
  depends_on  = [azurerm_subnet.subnet_apg_backend]
}
output "vnet_cass_name" {
  description = "Name of cassandra"
  value       = azurerm_virtual_network.vnet_cass.name
  depends_on  = [azurerm_virtual_network.vnet_cass]
}
output "vnet_psql_name" { #
  description = "Name of PostgreSQL"
  value       = azurerm_virtual_network.vnet_psql.name
  depends_on  = [azurerm_virtual_network.vnet_psql]
}
output "pdns_psql_vnet_link_psql" {
  description = ""
  value       = azurerm_private_dns_zone_virtual_network_link.pdns_psql_vnet_link_psql.name
  depends_on  = [azurerm_private_dns_zone_virtual_network_link.pdns_psql_vnet_link_psql]
}
output "pdns_redis_name" {
  description = ""
  value       = azurerm_private_dns_zone.pdns_redis.name
  depends_on  = [azurerm_private_dns_zone.pdns_redis]
}
