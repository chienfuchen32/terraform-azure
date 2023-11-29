variable "resource_group" {
  description = "resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "vnet_psql_name" {
  type = string
}

variable "subnet_psql_name" {
  type    = string
  default = "subnet-psql"
}

variable "address_prefixes_vnet_psql" {
  type    = list(string)
  default = ["10.17.0.0/16"]
}

variable "address_prefixes_subnet_psql" {
  type    = list(string)
  default = ["10.17.1.0/24"]
}

variable "vnet_app_name" {
  type = string
}

variable "subnet_aks_name" {
  type    = string
  default = "subnet-aks"
}

variable "subnet_pep_name" {
  type    = string
  default = "subnet-pep"
}

variable "subnet_lb_name" {
  type    = string
  default = "subnet-lb"
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

variable "address_prefixes_vnet_app" {
  type    = list(string)
  default = ["10.0.0.0/12"]
}

variable "address_prefixes_subnet_aks" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "address_prefixes_subnet_pep" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}

variable "address_prefixes_subnet_lb" {
  type    = list(string)
  default = ["10.1.2.0/24"]
}

variable "address_prefixes_subnet_frontend" {
  type    = list(string)
  default = ["10.1.3.0/24"]
}

variable "address_prefixes_subnet_backend" {
  type    = list(string)
  default = ["10.1.4.0/24"]
}

variable "vnet_cass_name" {
  type = string
}

variable "address_prefixes_vnet_cass" {
  type    = list(string)
  default = ["10.16.0.0/16"]
}

variable "subnet_cass_name" {
  type    = string
  default = "subnet-cass"
}

variable "address_prefixes_subnet_cass" {
  type    = list(string)
  default = ["10.16.1.0/24"]
}

variable "pdns_psql_name" {
  type = string
}

variable "pdns_redis_name" {
  type = string
}
