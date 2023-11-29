variable "project" {
  description = "prject"
  type        = string
}

variable "env" {
  description = "env"
  type        = string
}

variable "region" {
  description = "Azure region, for instance: sea represent Southeast Asia"
  type        = string
}

variable "resource_group" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
  default     = "Southeast Asia"
}

variable "subnet_aks_name" {
  description = ""
  type        = string
  default     = "subnet-aks"
}

variable "aks_tags" {
  type    = map(any)
  default = { ENV : "DEV" }
}

variable "aks_admin_group_object_ids" {
  description = "aks admin group object ids"
  type        = list(string)
  default     = []
}

variable "aks_namespace_admin_group_object_ids" {
  description = "aks namespace admin group object ids"
  type        = list(string)
  default     = []
}

variable "aks_default_node_pool" {
  description = ""
  type = object({
    name            = string
    vm_size         = string
    node_count      = number
    zones           = list(string)
    os_disk_size_gb = number
    os_disk_type    = string
  })
  default = {
    name = "monitor", vm_size = "Standard_DS4_v2", node_count = 2, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral"
  }
}

variable "aks_node_pool" {
  description = ""
  type = map(object({
    vm_size         = string
    node_count      = number
    zones           = list(string)
    os_disk_size_gb = number
    os_disk_type    = string
  }))
  default = {
    "mqpool" : { vm_size = "Standard_DS4_v2", node_count = 6, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral" }
    "tbcorepool" : { vm_size = "Standard_DS3_v2", node_count = 3, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral" }
    "tbrepool" : { vm_size = "Standard_DS3_v2", node_count = 25, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral" }
    "tbtranspool" : { vm_size = "Standard_DS3_v2", node_count = 12, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral" }
    "tbjspool" : { vm_size = "Standard_DS2_v2", node_count = 6, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral" }
  }
}

variable "cassandra_cluster" {
  type = map(object({
    name              = string
    cassandra_version = string
    password          = string
    data_center = map(object({
      name       = string
      location   = optional(string, "Southeast Asia")
      node_count = optional(number, 3)
      disk_count = optional(number, 4) # 4 * P30, 1024 GB, 5000 IOPS, 200 MB/sec throughput
      sku_name   = optional(string, "Standard_D8S_v5")
    }))
  }))
  default = {
    "tb" : {
      name              = "tb",
      cassandra_version = "4.0",
      password          = "",
      data_center = {
        "dc1-sea" : {
          name     = "dc1-sea",
          location = "Southeast Asia"
        }
      }
    }
  }
}

variable "psql_instance" {
  type = map(object({
    name         = string
    psql_version = optional(string, "14")
    zone         = optional(string, "1")
    storage_mb   = optional(number, 32768)
    sku_name     = optional(string, "B_Standard_B1ms")
    admin        = optional(string, "admin")
    password     = string
  }))
  default = {
    "tb" : { name = "tb", storage_mb = 262144, sku_name = "GP_Standard_D4s_v3", password = "" }
  }
}

variable "redis_instance" {
  type = map(object({
    name     = optional(string, "app")
    family   = optional(string, "C")
    capacity = optional(number, 0)
    sku_name = optional(string, "Standard")
  }))
  default = {
    "tb" : { name = "tb", capacity = 3 }
  }
}

