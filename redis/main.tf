provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_redis_cache" "redis" {
  name                = "redis"
  location            = var.location
  resource_group_name = var.resource_group
  capacity            = 3
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }
}
