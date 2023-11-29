locals {
  vnet_apg_name   = "virtual-network-apg-${var.project}-${var.env}-${var.region}"
  vnet_app_name   = "virtual-network-app-${var.project}-${var.env}-${var.region}"
  vnet_psql_name  = "virtual-network-psql-${var.project}-${var.env}-${var.region}"
  vnet_cass_name  = "virtual-network-cass-${var.project}-${var.env}-${var.region}"
  pdns_psql_name  = "private-dns-postgresql-${var.project}-${var.env}-${var.region}.private.postgres.database.azure.com"
  pdns_redis_name = "private-dns-dns-redis-${var.project}-${var.env}-${var.region}.privatelink.redis.cache.windows.net"
  aks_name        = "kubernetes-${var.project}-${var.env}-${var.region}"
  apg_name        = "applicatation-gateway-${var.project}-${var.env}-${var.region}"
  acr_name        = replace("containerregistry${var.project}${var.env}${var.region}", "-", "")
  pip_apg_name    = "public-ip-${local.apg_name}"
}

module "network" {
  source          = "../../modules/azure/network"
  resource_group  = var.resource_group
  location        = var.location
  vnet_app_name   = local.vnet_app_name
  vnet_psql_name  = local.vnet_psql_name
  vnet_cass_name  = local.vnet_cass_name
  pdns_psql_name  = local.pdns_psql_name
  pdns_redis_name = local.pdns_redis_name
}

module "apg" {
  source         = "../../modules/azure/application_gateway"
  resource_group = var.resource_group
  location       = var.location
  pip_apg_name   = local.pip_apg_name
  apg_name       = local.apg_name
  vnet_app_name  = local.vnet_app_name

  vnet_depends_on = [
    module.network.vnet_app_name,
    module.network.subnet_apg_frontend_name,
    module.network.subnet_apg_backend_name
  ]
}

module "acr" {
  source         = "../../modules/azure/acr"
  resource_group = var.resource_group
  location       = var.location
  acr_name       = local.acr_name
}

module "aks" {
  source                               = "../../modules/azure/kubernetes"
  resource_group                       = var.resource_group
  location                             = var.location
  vnet_app_name                        = local.vnet_app_name
  subnet_aks_name                      = var.subnet_aks_name
  aks_name                             = local.aks_name
  aks_namespace_admin_group_object_ids = var.aks_namespace_admin_group_object_ids
  aks_admin_group_object_ids           = var.aks_admin_group_object_ids
  apg_id                               = module.apg.apg_id
  acr_id                               = module.acr.acr_id
  aks_tags                             = var.aks_tags
  aks_default_node_pool                = var.aks_default_node_pool
  aks_node_pool                        = var.aks_node_pool

  vnet_depends_on = [
    module.network.vnet_app_name,
    module.apg.apg_id,
    module.acr.acr_id
  ]
}

module "cassandra" {
  source              = "../../modules/azure/cassandra"
  resource_group      = var.resource_group
  location            = var.location
  vnet_cassandra_name = local.vnet_cass_name

  for_each          = var.cassandra_cluster
  cassandra_name    = "cass-${each.value.name}-${var.project}-${var.env}-${var.region}"
  password          = each.value.password
  cassandra_version = each.value.cassandra_version
  data_center       = each.value.data_center

  vnet_depends_on = [
    module.network.vnet_cass_name
  ]
}

module "psql_flexible_server" {
  source         = "../../modules/azure/postgresql"
  resource_group = var.resource_group
  location       = var.location
  vnet_psql_name = local.vnet_psql_name
  pdns_psql_name = local.pdns_psql_name

  for_each     = var.psql_instance
  psql_name    = "psql-${each.value.name}-${var.project}-${var.env}-${var.region}"
  psql_version = each.value.psql_version
  storage_mb   = each.value.storage_mb
  admin        = each.value.admin
  password     = each.value.password
  sku_name     = each.value.sku_name
  zone         = each.value.zone

  vnet_depends_on = [
    module.network.vnet_psql_name,
    module.network.pdns_psql_vnet_link_psql
  ]
}

module "redis" {
  source          = "../../modules/azure/redis"
  resource_group  = var.resource_group
  location        = var.location
  vnet_app_name   = local.vnet_app_name
  pdns_redis_name = local.pdns_redis_name

  for_each   = var.redis_instance
  redis_name = "redis-${each.value.name}-${var.project}-${var.env}-${var.region}"
  sku_name   = each.value.sku_name
  family     = each.value.family
  capacity   = each.value.capacity
  vnet_depends_on = [
    module.network.vnet_app_name,
    module.network.pdns_redis_name
  ]
}
