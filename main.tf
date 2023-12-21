terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.85.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "tfstorage"
    storage_account_name = "tfstoraccountnerd"
    container_name = "statefile"
    key = "terraform.state"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "Poland Central"
  name     = "my_resoource_group"
}

resource "azurerm_service_plan" "sp" {
  name                  = "my_service_plan"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  os_type               = "Linux"
  sku_name              = "F1"
}

resource "azurerm_linux_web_app" "wa" {
  name                  = "nerdysoft-terraform-linux-app"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_service_plan.sp.location
  service_plan_id       = azurerm_service_plan.sp.id
  site_config {
    application_stack {
      dotnet_version = "7.0"
    }
    always_on = false
  }
}