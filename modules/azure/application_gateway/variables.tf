variable "resource_group" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

# application gateway
variable "apg_name" {
  description = ""
  type        = string
}

variable "pip_apg_name" {
  description = ""
  type        = string
}

variable "autoscale_min_capacity" {
  type    = number
  default = 2
}

variable "autoscale_max_capacity" {
  type    = number
  default = 10
}

variable "vnet_app_name" {
  description = ""
  type        = string
}

variable "subnet_apg_frontend_name" {
  description = ""
  type        = string
  default     = "subnet-apg-frontend"
}

variable "subnet_apg_backend_name" {
  description = ""
  type        = string
  default     = "subnet-apg-backend"
}

variable "sku_tier" {
  description = ""
  type        = string
  default     = "WAF_v2"
  validation {
    condition     = contains(["Standard", "Standard_v2", "WAF", "WAF_v2"], var.sku_tier)
    error_message = "Valid values for the sku_tier variable are Standard Standard_v2 WAF WAF_v2"
  }
}

variable "vnet_depends_on" {
  description = " the value doesn't matter; we're just using this variable to propagate dependencies."
  type        = any
  default     = []
}

