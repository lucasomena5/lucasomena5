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
}
