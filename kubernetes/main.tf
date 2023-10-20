provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = "aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "aks"
  kubernetes_version  = "1.26.3"

  default_node_pool {
    name       = "systempool"
    node_count = 2
    vm_size    = "Standard_D4s_v5"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Perf"
  }

  ingress_application_gateway {
    gateway_id = var.gateway_id
  }
  network_profile {
    network_plugin = "azure"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config_raw

  sensitive = true
}

resource "azurerm_kubernetes_cluster_node_pool" "node_monitor" {
  name                  = "monitorpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 2
}

resource "azurerm_kubernetes_cluster_node_pool" "node_mq" {
  name                  = "mqpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D8s_v5"
  node_count            = 6
}

resource "azurerm_kubernetes_cluster_node_pool" "node_core" {
  name                  = "tbcorepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 3
}

resource "azurerm_kubernetes_cluster_node_pool" "node_rule_engine" {
  name                  = "tbrepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 25
}

resource "azurerm_kubernetes_cluster_node_pool" "node_js_executor" {
  name                  = "tbjspool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D2s_v5"
  node_count            = 6
}

resource "azurerm_kubernetes_cluster_node_pool" "node_transport" {
  name                  = "tbtranspool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  vm_size               = "Standard_D4s_v5"
  node_count            = 12
}
