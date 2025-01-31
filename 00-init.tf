terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "stephen-blob"
    storage_account_name = "stephenstorage"
    container_name       = "stephen-blob"
  }

  required_version = "1.10.5"
}

provider "azurerm" {
  features {}
  subscription_id = "d38fa016-777f-4647-bbc8-0aaf1933103c"
}

resource "azurerm_resource_group" "this" {
  name     = "${var.team_name}-tf-rg"
  location = var.location
}
