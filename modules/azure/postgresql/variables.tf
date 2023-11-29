variable "resource_group" {
  type        = string
  description = "resource group"
}

variable "location" {
  type        = string
  description = "location"
}

# psql
variable "vnet_psql_name" {
  type        = string
  description = ""
}

variable "subnet_psql_name" {
  type    = string
  default = "subnet-psql"
}

variable "pdns_psql_name" {
  type = string
}

variable "psql_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "admin" {
  type = string
}

variable "password" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "storage_mb" {
  type = number
}

variable "psql_version" {
  type = string
}

variable "vnet_depends_on" {
  description = " the value doesn't matter; we're just using this variable to propagate dependencies."
  type        = any
  default     = []
}
