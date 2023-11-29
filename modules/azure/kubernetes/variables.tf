variable "resource_group" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

# apg
variable "apg_id" {
  description = ""
  type        = string
}

# acr
variable "acr_id" {
  description = ""
  type        = string
}

# k8s
variable "vnet_app_name" {
  description = ""
  type        = string
}

variable "aks_name" {
  description = ""
  type        = string
}

variable "aks_version" {
  description = ""
  type        = string
  default     = "1.27.3"
}

variable "aks_tags" {
  type    = map(any)
  default = {}
}

variable "subnet_aks_name" {
  type    = string
  default = "subnet-aks"
}

variable "vnet_depends_on" {
  description = " the value doesn't matter; we're just using this variable to propagate dependencies."
  type        = any
  default     = []
}

variable "aks_admin_group_object_ids" {
  description = "aks admin group object ids"
  type        = list(string)
}

variable "aks_namespace_admin_group_object_ids" {
  description = "aks namespace admin group object ids"
  type        = list(string)
}

variable "dns_service_ip" {
  description = ""
  type        = string
  default     = "10.10.0.10"
}

variable "service_cidr" {
  description = ""
  type        = string
  default     = "10.10.0.0/16"
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
    name = "monitorpool", vm_size = "Standard_DS4_v2", node_count = 1, zones = ["1", "2"], os_disk_size_gb = 64, os_disk_type = "Ephemeral"
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
  default = {}
}
