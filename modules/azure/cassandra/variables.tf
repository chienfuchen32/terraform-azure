variable "resource_group" {
  type        = string
  description = "resource group"
}

variable "location" {
  type        = string
  description = "location"
}

variable "vnet_cassandra_name" {
  type        = string
  description = ""
}

variable "subnet_cass_name" {
  type    = string
  default = "subnet-cass"
}

variable "cassandra_name" {
  type        = string
  description = ""
}

variable "password" {
  type = string
}

variable "cassandra_version" {
  type = string
}

variable "vnet_depends_on" {
  description = " the value doesn't matter; we're just using this variable to propagate dependencies."
  type        = any
  default     = []
}

variable "data_center" {
  type = map(object({
    name       = string
    location   = optional(string, "Southeast Asia")
    node_count = optional(number, 3)
    disk_count = optional(number, 4) # 4 * P30, 1024 GB, 5000 IOPS, 200 MB/sec throughput
    sku_name   = optional(string, "Standard_D8S_v5")
  }))
  default = {
    "dc1_sea" : {
      name = "dc1_sea",
    }
  }
}
