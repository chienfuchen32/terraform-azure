output "apg_id" {
  description = "ID of APG"
  value       = azurerm_application_gateway.application_gateway.id
  depends_on  = [azurerm_application_gateway.application_gateway]
}
