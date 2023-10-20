variable "resource_group" {
  type        = string
  description = "resource group"
  default     = "terraform-azure"
}

variable "location" {
  type        = string
  description = "location"
  default     = "Southeast Asia"
}

variable "vnet_name" {
  type        = string
  description = "virtual network name"
  default     = "vnet-psql"
}
