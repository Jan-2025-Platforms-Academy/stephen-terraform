terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "stephen-blob"
    storage_account_name = "stephenstorage"
    container_name = "stephen-blob"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d38fa016-777f-4647-bbc8-0aaf1933103c"
}