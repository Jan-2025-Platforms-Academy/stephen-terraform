terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  subscription_id = "d38fa016-777f-4647-bbc8-0aaf1933103c"
}

resource "azurerm_resource_group" "this" {
  name     = "${var.team_name}-tf-rg"
  location = var.location
}
