terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tflablucasomena5trial"
    container_name       = "tf-state"
    key                  = "terraform/azure/lab.tfstate"
  }

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">=3.49.0"
    }
  }
  
  required_version = ">=1.4"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}
