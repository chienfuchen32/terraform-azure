output "acr_id" {
  description = "ID of ACR"
  value       = azurerm_container_registry.acr.id
  depends_on  = [azurerm_container_registry.acr]
}
