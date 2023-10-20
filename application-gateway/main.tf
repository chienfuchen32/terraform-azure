provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_virtual_network" "vnet_application_gateway" {
  name                = "vnet-application-gateway"
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_application_gateway.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet_application_gateway.name
  address_prefixes     = ["10.254.2.0/24"]
}

resource "azurerm_public_ip" "pip_application_gateway" {
  name                = "pip-application-gateway"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku  = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet_application_gateway.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet_application_gateway.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet_application_gateway.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet_application_gateway.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet_application_gateway.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet_application_gateway.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet_application_gateway.name}-rdrcfg"
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = "appgateway"
  resource_group_name = var.resource_group
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip_application_gateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
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
