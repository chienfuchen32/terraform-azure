locals {
  backend_address_pool_name      = "${var.vnet_app_name}-beap"
  frontend_port_name             = "${var.vnet_app_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_app_name}-feip"
  http_setting_name              = "${var.vnet_app_name}-be-htst"
  listener_name                  = "${var.vnet_app_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_app_name}-rqrt"
  redirect_configuration_name    = "${var.vnet_app_name}-rdrcfg"
}

resource "azurerm_public_ip" "pip_apg" {
  name                = var.pip_apg_name
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = var.apg_name
  resource_group_name = var.resource_group
  location            = var.location
  enable_http2        = true

  sku {
    name = "WAF_v2"
    tier = var.sku_tier
  }

  autoscale_configuration {
    min_capacity = var.autoscale_min_capacity
    max_capacity = var.autoscale_max_capacity
  }

  gateway_ip_configuration {
    name      = "configuration"
    subnet_id = data.azurerm_subnet.subnet_frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip_apg.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  waf_configuration {
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
    enabled          = true
  }
}
