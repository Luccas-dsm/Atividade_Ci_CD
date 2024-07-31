terraform {
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = "aula04"
    storage_account_name = "storageaula04"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }


  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
  }
}

provider "azurerm" {

  features {}

}
