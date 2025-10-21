terraform {
  backend "remote" {
    organization = "terraform-organisatie"

    workspaces {
      name = "workspace"
    }
  }

  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = "c064671c-8f74-4fec-b088-b53c568245eb"
  features {}
}
