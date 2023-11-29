# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                          = var.redis_name
  location                      = var.location
  resource_group_name           = var.resource_group
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }
}

resource "azurerm_private_endpoint" "private_endpoint" {
  count               = 1
  name                = "pep-${var.redis_name}"
  resource_group_name = var.resource_group
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnet_pep.id

  private_service_connection {
    name                           = "connection-pep-${var.redis_name}"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }
  depends_on = [data.azurerm_private_dns_zone.pdns_redis]
}


resource "azurerm_private_dns_a_record" "record" {
  name                = "record-${var.redis_name}"
  zone_name           = data.azurerm_private_dns_zone.pdns_redis.name
  resource_group_name = var.resource_group
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint[0].private_service_connection[0].private_ip_address]
  depends_on          = [azurerm_private_endpoint.private_endpoint]
}

