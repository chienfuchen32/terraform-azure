variable "resource_group" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "redis_name" {
  type = string
}

variable "pdns_redis_name" {
  type = string
}

variable "vnet_app_name" {
  description = ""
  type        = string
}

variable "subnet_pep_name" {
  type    = string
  default = "subnet-pep"
}

variable "family" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "capacity" {
  type = number
}

variable "vnet_depends_on" {
  description = " the value doesn't matter; we're just using this variable to propagate dependencies."
  type        = any
  default     = []
}
