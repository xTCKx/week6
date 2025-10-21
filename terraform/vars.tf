variable "esxi_hostname" {
  type    = string
  default = "192.168.1.7"
}

variable "esxi_hostport" {
  type    = string
  default = "22"
}

variable "esxi_hostssl" {
  type    = string
  default = "443"
}

variable "esxi_username" {
  type    = string
  default = "root"
}

variable "esxi_password" {
  type    = string
  default = "Welkom01!"
}

variable "disk_store" {
  type    = string
  default = "datastore1"
}

variable "vm_memsize" {
  type    = number
  default = 2048
}

variable "vm_numvcpus" {
  type    = number
  default = 1
}

variable "ovf_source" {
  type    = string
  default = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}

variable "virtual_network" {
  type    = string
  default = "VM Network"
}

variable "resource_group_name" {
  type    = string
  default = "S1201431"
}

variable "virtual_network_name" {
  type    = string
  default = "azurerm-vnet"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "azurerm-internal"
}

variable "subnet_address_prefixes" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}

variable "allocation_method" {
  type    = string
  default = "Static"
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  type    = string
  default = "iac"
}

