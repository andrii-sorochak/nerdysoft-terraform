terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.85.0"
    }
  }
}

provider "azurerm" {
  features { }
}

resource "azurerm_resource_group" "rg" {
  name      = "test-delete-later"
  location  = "Poland central"
}

resource "azurerm_service_plan" "sp" {
  name                = "my-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "example" {
  name                = "nerdysoft-terraform-linux-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      dotnet_version = "7.0"
    }

    always_on         = false
  }
}