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

variable "gateway_id" {
  type        = string
  description = "application gateway id"
  default     = ""
}
