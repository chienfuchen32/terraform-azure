resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                      = var.aks_name
  location                  = var.location
  resource_group_name       = var.resource_group
  dns_prefix                = "dns-${var.aks_name}"
  kubernetes_version        = var.aks_version
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  sku_tier                  = "Standard"

  default_node_pool {
    orchestrator_version   = var.aks_version
    max_pods               = 110
    enable_auto_scaling    = false
    os_sku                 = "Ubuntu"
    enable_host_encryption = true
    vnet_subnet_id         = data.azurerm_subnet.subnet_aks.id
    kubelet_config {
      image_gc_high_threshold = 60
      image_gc_low_threshold  = 40
    }

    name            = var.aks_default_node_pool.name
    vm_size         = var.aks_default_node_pool.vm_size
    node_count      = var.aks_default_node_pool.node_count
    zones           = var.aks_default_node_pool.zones
    os_disk_type    = var.aks_default_node_pool.os_disk_type
    os_disk_size_gb = var.aks_default_node_pool.os_disk_size_gb

    tags = var.aks_tags
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.aks_admin_group_object_ids
    azure_rbac_enabled     = true
  }

  tags = var.aks_tags

  ingress_application_gateway {
    gateway_id = var.apg_id
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = var.dns_service_ip
    service_cidr      = var.service_cidr
    load_balancer_sku = "standard"
    load_balancer_profile {
      idle_timeout_in_minutes = 30
    }
    network_mode   = "transparent"
    network_policy = "azure"
  }
  azure_policy_enabled = false

  storage_profile {
    blob_driver_enabled = true
  }
  workload_autoscaler_profile {
    vertical_pod_autoscaler_enabled = true
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.kubernetes_cluster.kube_config_raw
  sensitive = true
}

resource "azurerm_kubernetes_cluster_node_pool" "vmss" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.kubernetes_cluster.id
  orchestrator_version   = var.aks_version
  max_pods               = 110
  enable_auto_scaling    = false
  os_sku                 = "Ubuntu"
  enable_host_encryption = true
  vnet_subnet_id         = data.azurerm_subnet.subnet_aks.id
  kubelet_config {
    image_gc_high_threshold = 55
    image_gc_low_threshold  = 20
  }

  for_each        = var.aks_node_pool
  name            = each.key
  vm_size         = each.value.vm_size
  node_count      = each.value.node_count
  zones           = each.value.zones
  os_disk_type    = each.value.os_disk_type
  os_disk_size_gb = each.value.os_disk_size_gb
  tags            = var.aks_tags
}

# for acr role assignment
resource "azurerm_role_assignment" "role_assignment_acr" {
  principal_id                     = azurerm_kubernetes_cluster.kubernetes_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
  depends_on                       = [var.vnet_depends_on]
}

# for platform team admin role assignment
resource "azurerm_role_assignment" "role_assignment_cluster_user_role" {
  for_each             = toset(var.aks_namespace_admin_group_object_ids)
  scope                = azurerm_kubernetes_cluster.kubernetes_cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

# for application team role assignment
resource "azurerm_role_assignment" "role_assignment_rbac_writer" {
  for_each             = toset(var.aks_namespace_admin_group_object_ids)
  scope                = azurerm_kubernetes_cluster.kubernetes_cluster.id
  role_definition_name = "Azure Kubernetes Service RBAC Writer"
  principal_id         = each.value
}
